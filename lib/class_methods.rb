module SerializedAccessors
  module ClassMethods
    #valid options:
    # :default - if undefined, this plugin will create an empty instance of the defined type or null
    # :type - defaults to :string. Can also be :integer, :float, :boolean, or :array
    #
    # for arrays only:
    # :collects - only runs on arrays. Calls the lambda method on each item in the array before saving
    # :reject_blanks - removes all blank elements after the collect method
    def serialized_accessor(hash_name, method_name, options = {})
      method_modifier = ""
      begin
      
        if options[:type]==:integer
          method_modifier = "new_val = new_val.to_i"
        elsif options[:type]==:float
          method_modifier = "new_val = new_val.to_f"
        elsif options[:type]==:boolean or options[:type]==:bool
          method_modifier = "new_val = (new_val.is_a?(TrueClass) or (new_val.is_a?(String) and (new_val=~/true|1/i).present?) or (new_val.is_a?(Fixnum) and new_val==1))"
        elsif options[:type]==:array
          method_modifier = "new_val = [new_val] unless new_val.is_a?(Array)"

          if options[:collects]
            self.class_variable_set("@@lambda_for_#{method_name}", options[:collects])
            method_modifier += "\nnew_val = new_val.collect(&@@lambda_for_#{method_name})"
          end
        
          if options[:reject_blanks]
            method_modifier += "\nnew_val = new_val.reject(&:blank?)"
          end
        end



        if options[:default].is_a?(String)
          default = "\"#{options[:default]}\""
        elsif options[:default].nil? and options[:type]==:array
          default = "[]"
        elsif options[:default].nil?
          default = "nil"
        else
          default = options[:default]
        end

str = <<-EOS
def #{method_name}
self.#{hash_name} ||= {}

if self.#{hash_name}[:#{method_name}].nil?
  self.#{hash_name}[:#{method_name}] = #{default}
end

self.#{hash_name}[:#{method_name}]
end

def #{method_name}=(new_val)
self.#{hash_name} ||= {}
#{method_modifier}

if self.#{hash_name}[:#{method_name}] != new_val
  @#{method_name}_changed = true
end

self.#{hash_name}[:#{method_name}] = new_val
end

def #{method_name}_changed?
!!@#{method_name}_changed
end
EOS

        if options[:type]==:boolean or options[:type]==:bool
str += <<-EOS
def #{method_name}?
!!self.#{method_name}
end
EOS
        end

        class_eval str
      rescue Exception => e
        puts "\n\nError adding serialized_accessor:\n#{e.message}\n#{e.backtrace}\n\n"
      end
    
    end
  end
  
end
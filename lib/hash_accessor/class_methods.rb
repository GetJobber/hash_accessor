require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/array/wrap'
require "bigdecimal"
require "bigdecimal/util"

module HashAccessor
  module ClassMethods

    #valid options:
    # :default - if undefined, this plugin will create an empty instance of the defined type or null
    # :type - defaults to :string. Can also be :integer, :float, :boolean, or :array
    #
    # for arrays only:
    # :collects - only runs on arrays. Calls the lambda method on each item in the array before saving
    # :reject_blanks - removes all blank elements after the collect method
    def hash_accessor(hash_name, method_name, options = {})
      begin
        method_modifier = hash_accessor_method_modifier(method_name, options)
        default = hash_accessor_default(options)

        # Define getter
        define_method(method_name) do
          send("#{hash_name}=", {}) if send(hash_name).blank?
          if self.send(hash_name)[method_name].nil?
            self.send(hash_name)[method_name] = default
          end
          self.send(hash_name)[method_name]
        end

        # Define setter
        define_method("#{method_name}=") do |*args|
          new_val = args[0]
          self.send("#{hash_name}=", {}) if send(hash_name).blank?
          new_val = method_modifier.call(new_val)
          if self.send(hash_name)[method_name] != new_val
            instance_variable_set("@#{method_name}_changed", true)
          end
          self.send(hash_name)[method_name] = new_val
        end

        # Define changed?
        define_method("#{method_name}_changed?") do
          !!instance_variable_get("@#{method_name}_changed")
        end

        # Define special boolean accessor
        if options[:type]==:boolean or options[:type]==:bool
          define_method("#{method_name}?") do
            !!send(method_name)
          end
        end

      rescue Exception => e
        puts "\n\nError adding hash_accessor:\n#{e.message}\n#{e.backtrace}\n\n"
      end
    end

    private

    def hash_accessor_method_modifier(method_name, options)
      case options[:type]
      when :integer
        lambda {|new_val| new_val.try(:to_i) }
      when :float
        lambda {|new_val| new_val.try(:to_f) }
      when :decimal
        lambda {|new_val| new_val.try(:to_d) }
      when :boolean, :bool
        lambda {|new_val| (new_val.is_a?(TrueClass) or (new_val.is_a?(String) and (new_val=~/true|1/i).present?) or (new_val.is_a?(Fixnum) and new_val==1)) }
      when :array
        lambda {|new_val|
          new_val = Array.wrap(new_val)

          if options[:collects]
            new_val = new_val.collect(&options[:collects])
          end

          if options[:reject_blanks]
            new_val.reject!(&:blank?)
          end

          new_val
        }
      else lambda {|new_val| new_val}
      end
    end

    def hash_accessor_default(options)
      if options[:default].is_a?(String)
        default = options[:default]
      elsif options[:default].nil? and options[:type]==:array
        default = []
      elsif options[:default].nil?
        default = nil
      else
        default = options[:default]
      end
    end
  end

end

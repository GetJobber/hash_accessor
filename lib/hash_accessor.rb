$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'hash_accessor/railtie' if defined?(Rails)

module HashAccessor
  VERSION = "0.1.0"
  
  autoload :ClassMethods, 'hash_accessor/class_methods'  
  
  def self.included(mod)
    mod.extend(ClassMethods)
  end

end
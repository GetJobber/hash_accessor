module SerializedAccessors
  class Railtie < Rails::Railtie

    config.to_prepare do
      ActiveRecord::Base.send :include SerializedAccessors      
    end
    
  end
end
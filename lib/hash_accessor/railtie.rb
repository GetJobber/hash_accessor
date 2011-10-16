module HashAccessor
  class Railtie < Rails::Railtie

    config.to_prepare do
      ActiveRecord::Base.send :include, HashAccessor      
    end
    
  end
end
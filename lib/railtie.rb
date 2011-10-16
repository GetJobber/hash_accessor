module hashAccessor
  class Railtie < Rails::Railtie

    config.to_prepare do
      ActiveRecord::Base.send :include hashAccessor      
    end
    
  end
end
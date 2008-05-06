namespace :radiant do
  namespace :extensions do
    namespace :z_bkr_interface do
      
      desc "Runs the migration of the Z Bkr Interface extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ZBkrInterfaceExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ZBkrInterfaceExtension.migrator.migrate
        end
      end
    
    end
  end
end
namespace :radiant do
  namespace :extensions do
    namespace :shards do
      
      desc "Runs the migration of the Shards extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ShardsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ShardsExtension.migrator.migrate
        end
      end
    
    end
  end
end
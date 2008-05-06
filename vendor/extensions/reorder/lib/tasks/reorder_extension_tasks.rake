namespace :radiant do
  namespace :extensions do
    namespace :reorder do
      
      desc "Runs the migration of the Reorder extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ReorderExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ReorderExtension.migrator.migrate
        end
      end
    
      namespace :update do
        desc "Copies the public assets of the Reorder extension into the instance's public directory"
        task :public => :environment do
          root = File.expand_path(ReorderExtension.root)
          sources = Dir.glob(File.join(root, 'public', '*'))
          radiant_root = File.expand_path(RADIANT_ROOT)
          destination = File.join(radiant_root, 'public')
          cp_r sources, destination
        end
      end
      
    end
  end
end
namespace :radiant do
  namespace :extensions do
    namespace :legacy_tags do
      
      desc "Runs the migration of the legacy_tags extension"
      task :migrate do
        require 'extension_migrator'
        LegacyTagsExtension.migrator.migrate
      end
    
    end
  end
end
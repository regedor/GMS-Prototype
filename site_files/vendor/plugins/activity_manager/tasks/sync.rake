namespace :projects do
  namespace :sync do
    task :db do
      system "rsync -ruv vendor/plugins/activity_manager/db/migrate db"
    end
    
    task :css do  
      system "rsync -ruv vendor/plugins/activity_manager/public/stylesheets/ public/stylesheets/projects_plugin"
    end
    
    task :all  => [:db,:css]  
  end  
end  
namespace :projects do
  task :sync do
    system "rsync -ruv vendor/plugins/activity_manager/db/migrate db"
    system "rsync -ruv vendor/plugins/activity_manager/public/stylesheets public/stylesheets/projects_plugin"
  end  
end  
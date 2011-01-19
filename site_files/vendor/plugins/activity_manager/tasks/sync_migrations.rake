namespace :projects do
  task :sync do
    system "rsync -ruv vendor/plugins/activity_manager/db/migrate db"
  end  
end  
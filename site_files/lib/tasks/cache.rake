namespace :cache do
  task :clear => :environment do
    require 'fileutils'
    FileUtils.rm_rf 'public/stylesheets/cache'
    FileUtils.rm_rf 'public/javascripts/cache'
    Rake::Task['tmp:cache:clear'].invoke
  end
end
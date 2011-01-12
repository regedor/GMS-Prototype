namespace :db do
  namespace :fill do
    namespace :fake_data do

      task :posts => :environment do
        load 'lib/tasks/fake_data/posts.rb'
        puts "How many posts to fake?"
        STDIN.gets.chomp.to_i.times do 
          i = (rand * @posts_titles.size).to_i
          Post.create(
            :title                   => @posts_titles[i],
            :body                    => @posts_bodies[i], 
            :active                  => true, 
            :approved_comments_count => 0, 
            :published_at            => Time.now, 
            :edited_at               => nil, 
            :updated_at              => nil
          ) 
        end
        puts "Done"
      end

      task :announcements => :environment do
        load 'lib/tasks/fake_data/announcements.rb'
        puts "How many announcements to fake?"
        STDIN.gets.chomp.to_i.times do
          i = (rand * @announcements_titles.size).to_i
          year  = 2000+(rand * 5).to_i
          month = ((rand * 11)+1).to_i
          day   = ((rand * 25)+1).to_i
          
          year2  = 2011+(rand * 5).to_i
          month2 = ((rand * 11)+1).to_i
          day2   = ((rand * 25)+1).to_i
            
          Announcement.create(
            :title      => @announcements_titles[i], 
            :headline   => @announcements_headlines[i], 
            :message    => @announcements_messages[i], 
            :avatar     => File.open( "public/images/announcements/"+()i.to_s+".png" ),
            :starts_at  => Time.local(year, month, day),
            :ends_at    => Time.local(year2,month2 ,day2),
            :created_at => Time.now
          )
        end
        puts "Done"
      end

      task :all => [:posts]

    end


    task :all => []
  end
end

namespace :db do
  namespace :fill do
    namespace :fake_data do

      task :posts => :environment do
        load 'lib/tasks/posts.rb'
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

      task :all => [:posts]

    end

    task :all => []
  end
end

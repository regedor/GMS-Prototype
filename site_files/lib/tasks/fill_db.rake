namespace :db do
  namespace :fill do
    namespace :fake_data do

      task :posts => :environment do
        load 'lib/tasks/posts.rb'
        gets.chomp.to_i.times do 
          i = (rand * posts_titles.size).to_i
          Post.create(
            :title                   => posts_titles[i], 
            :body                    => posts_bodies[i], 
            :active                  => true, 
            :approved_comments_count => 0, 
            :published_at            => Time.now, 
            :edited_at               => nil, 
            :updated_at              => nil
          ) 
        end
        puts "Concluido!"
      end
      task :all => [:posts]
    end

    task :all => []
  end
end

namespace :themes do
  task :choose => :environment do
    puts "Select the theme that you want to activate:"
    paths = Dir[RAILS_ROOT+'/app/themes/overrides/*']
    paths.each_with_index do | path, i | 
      puts i.to_s + " - " + path.split("/").last 
    end
    theme_path = paths[STDIN.gets.chomp.to_i]
    cp_r(theme_path+'/.', RAILS_ROOT) 

    #puts "----"+theme+"--"
  end
end

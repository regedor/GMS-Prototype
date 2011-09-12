class Gallery  
    
  class << self
    def get_albums(basedir="public/assets/images/thumbs")
      album_names=Dir.new(basedir).entries.select{|e| File::directory?(basedir+"/"+e)}.drop 2
      albums_and_images = []
      album_names.each do |album|      
        albums_and_images << Album.new(:name => album, :images => Dir.new(basedir+"/"+album).entries.drop(2))
      end  
      albums_and_images
    end
    
    # To be replaced with table and images to be replaced with table for paperclip
    def album_by_name(album_name,basedir="public/assets/images/thumbs")
      Album.new(:name => album_name, :images => Dir.new(basedir+"/"+album_name).entries.drop(2))
    end  
    
    def image_size(image_name,basedir="public/assets/images")
      %x[identify -format %w,%h #{basedir}/#{image_name}].chomp!
    end    
  end
  
  class Album
    
    
  end  
  
end  
class Gallery  
    
  class << self
    def get_albums(basedir="public/assets/images/thumbs")
      album_names=%x[public/assets/images/get_images.sh #{basedir}].split("\n") #How to do in ruby?
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
    
    attr_accessor :name, :images
    
    def initialize(*args)
      @name = args[0][:name]
      @images = args[0][:images]
    end  
    
    def cover
      @images.first
    end  
    
  end  
  
end  
class Gallery  
    
  class << self
    def get_albums(basedir="public/assets/images/thumbs")
      album_names=Dir.new(basedir).entries.select{|e| File::directory?(basedir+"/"+e)}.drop 2
      album_names.each do |album|
        new_album = Album.new :name => album   
        Dir.new(basedir+"/"+album).entries.drop(2).each do |image_path|
          new_album.images << Image.create(:path => image_path)
        end  
        new_album.save
      end  
      Album.all
    end
    
    # To be replaced with table and images to be replaced with table for paperclip
    def album_by_name(album_name,basedir="public/assets/images/thumbs")
      Album.new(:name => album_name, :images => Dir.new(basedir+"/"+album_name).entries.drop(2))
    end  
    
    def image_size(image_name,basedir="public/assets/images")
      %x[identify -format %w,%h #{basedir}/#{image_name}].chomp!
    end    
  end
  
end  
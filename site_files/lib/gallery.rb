class Gallery
    
  class << self
    def get_images(basedir="public/assets/images/thumbs")
      Dir.new(basedir).entries.drop 2  # Remove . and ..
    end
    
    def image_size(image_name,basedir="public/assets/images")
      %x[identify -format %w,%h #{basedir}/#{image_name}].chomp!
    end    
  end
  
end  
class GalleryController < ApplicationController
  
  def index 
    @images = Gallery.get_images
  end  
  
end  
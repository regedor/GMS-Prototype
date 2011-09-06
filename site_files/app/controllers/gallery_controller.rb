class GalleryController < ApplicationController
  
  def index 
    @albums = Gallery.get_albums
  end  
  
  def show
    @images = Gallery.album_by_name(params[:id]).images
    @album = params[:id]
  end  
  
end  
class GalleryController < ApplicationController
  
  def index 
    @albums = Gallery.get_albums
  end  
  
  def show
    @album = Album.find_by_name(params[:id])
    @images = @album.images   
  end  
  
end  
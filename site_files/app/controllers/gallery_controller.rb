class GalleryController < ApplicationController
  
  def index 
    @albums = Gallery.get_albums
  end  
  
  def show
    @images = Gallery.album_by_name(params[:id]).images #Having the id as the name is cool, add index?
    @album = params[:id]
  end  
  
end  
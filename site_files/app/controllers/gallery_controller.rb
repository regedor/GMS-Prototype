class GalleryController < ApplicationController
  
  def index 
    @albums = Gallery.get_albums
  end  
  
  def show
    @album = Album.find_by_name(params[:id])
    @images = @album.images   
  end  
  
  def new
    @album = Album.new
  end  
  
  def create
    @album = Album.new params[:album]
    @album.save
    
    if @album.save
      flash[:notice] = t("flash.album_created", :name => @album.name)
      redirect_to gallery_index_path
    else
      @template.properly_show_errors(@album)
      flash.now[:error] = t("flash.album_not_created", :name => @album.name)
      render :new
    end
  end  
  
end  
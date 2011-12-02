class AlbumsController < ApplicationController

  def new
    @album = Album.new
  end  

  def create
    @album = Album.new params[:album]
    @album.save

    if @album.save
      flash[:notice] = t("flash.album_created", :name => @album.name)
      redirect_to albums_path
    else
      @template.properly_show_errors(@album)
      flash.now[:error] = t("flash.album_not_created", :name => @album.name)
      render :new
    end
  end

  def index
     @albums = Album.all
  end
  
  def show
    @album = Album.find(params[:id])
    @images = @album.images
  end

end
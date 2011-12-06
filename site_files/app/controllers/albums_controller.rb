class AlbumsController < ApplicationController

  def new
    @album = Album.new
  end  

  def create
    @album = Album.new params[:album]
    @album.image_ids = params[:images].split(",").map(&:to_i)

    if @album.save
      flash[:notice] = t("flash.album_created", :name => @album.name)
      render :json => { :saved => true, :url => albums_url }
    else
      #@template.properly_show_errors(@album)
      #flash.now[:error] = t("flash.album_not_created", :name => @album.name)
      render :json => { :saved => false ,:text  => t("flash.album_not_created", :name => @album.name)}
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
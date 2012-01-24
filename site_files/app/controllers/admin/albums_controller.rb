class Admin::AlbumsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  
  active_scaffold :album do |config|
    #config.list.sorting = {:published_at => :desc}
    Scaffoldapp::active_scaffold config, "admin.album",
      :list   => [ :name, :created_at ],
      :show   => [],
      :create => [],
      :edit   => []
  end
  
  def new
    @album = Album.new
  end  

  def show
    redirect_to album_path(params[:id])
  end

  def create
    @album = Album.new params[:album]
    @album.image_ids = params[:images].split(",").map(&:to_i) if params[:images]

    if @album.save
      flash[:notice] = t("flash.album_created", :name => @album.name)
      render :json => { :saved => true, :url => albums_url }
    else
      #@template.properly_show_errors(@album)
      #flash.now[:error] = t("flash.album_not_created", :name => @album.name)
      render :json => { :saved => false ,:text  => t("flash.album_not_created", :name => @album.name)}
    end
  end

  def edit
    @album = Album.find params[:id]
  end

  def update
    @album = Album.find params[:id]
    @album.image_ids = params[:images].split(",").map(&:to_i) if params[:images]

    if @album.update_attributes params[:album]
      flash[:notice] = t("flash.album_created", :name => @album.name)
      render :json => { :saved => true, :url => albums_url }
    else
      #@template.properly_show_errors(@album)
      #flash.now[:error] = t("flash.album_not_created", :name => @album.name)
      render :json => { :saved => false ,:text  => t("flash.album_not_created", :name => @album.name)}
    end
  end
  
  def all_images
    @album = Album.find params[:id]
    render :json  => @album.images.map { |image| image.templatify }
  end
end
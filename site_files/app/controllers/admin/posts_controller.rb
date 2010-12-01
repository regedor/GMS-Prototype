class Admin::PostsController < Admin::BaseController
  before_filter :find_post, :only => [:show, :update, :destroy]

  active_scaffold :post do |config|
    config.actions.exclude :update, :delete
    config.actions << :update
    config.actions << :delete
 
    config.update.link = false
    config.actions.swap :search, :live_search
    config.create.link.inline = false
    config.show.link.inline = false
 
    Scaffoldapp::active_scaffold config, "admin.posts", [
      :title, :excert, :published_at, :total_approved_comments
    ]

  end

  def custom_finder_options
    # '@tag_ids' comes from the index method
    if @tag_ids.empty?
      return {}
    elsif @tag_ids.size == 1
      return {
         :joins => :taggings,
         :conditions => { "taggings.tag_id" => @tag_ids }
      }
    else
      return { 
         :from       => "(" + Post.send(:construct_finder_sql, 
         {
           :select     => "*, COUNT(*) as tag_count", 
           :group      => "taggings.taggable_id",  
           :joins      => :taggings, 
           :conditions => { "taggings.tag_id" => @tag_ids }
         }) + ") as posts",
         :conditions => { "tag_count" => @tag_ids.size }
      }
    end
  end


  def index
    @tag_ids = (params[:tag_ids] ? params[:tag_ids] : [])
    @tag_ids = [] if @tag_ids.is_a? Hash

    if @tag_ids.empty?
      @tags = Tag.paginate :page => params[:tag_page],
                           :per_page => 5,
                           :order => 'taggings_count DESC',
                           :conditions => 'taggings_count > 0'
    elsif @tag_ids.size == 1
      @tags = Tag.paginate :page => params[:tag_page],
                           :per_page => 5,
                           :select => "tags.id, tags.name, COUNT(*) as taggings_count",
                           :order => 'taggings_count DESC',
                           :joins => "INNER JOIN taggings ON tags.id = taggings.tag_id",
                           :group => "tags.id", 
                           :conditions => "taggings.taggable_id IN (" + Post.send(:construct_finder_sql,
                             {
                               :select => "posts.id",
                               :joins => :taggings,
                               :conditions => { "taggings.tag_id" => @tag_ids }
                             }) + ")"
    else
      @tags = Tag.paginate :page => params[:tag_page],
                           :per_page => 5,
                           :select => "tags.id, tags.name, COUNT(*) as taggings_count",
                           :order => 'taggings_count DESC',
                           :joins => "INNER JOIN taggings ON tags.id = taggings.tag_id",
                           :group => "tags.id", 
                           :conditions => "taggings.taggable_id IN (" + Post.send(:construct_finder_sql,
                             {
                               :select     => "posts.id",
                               :from       => "(" + Post.send(:construct_finder_sql, 
                                 {
                                   :select     => "posts.id, COUNT(*) as tag_count", 
                                   :group      => "taggings.taggable_id",  
                                   :joins      => :taggings, 
                                   :conditions => { "taggings.tag_id" => @tag_ids }
                                 }) + ") as posts",
                               :conditions => { "tag_count" => @tag_ids.size }
                             }) + ")"
    end
    super
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      respond_to do |format|
        format.html {
          flash[:notice] = I18n::t('flash.post_created', :title => @post.title)
          redirect_to(:action => 'show', :id => @post)
        }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new',         :status => :unprocessable_entity }
      end
    end
  end

  def update
    if @post.update_attributes(params[:post])
      respond_to do |format|
        format.html {
          flash[:notice] = I18n::t('flash.post_updated', :title => @post.title)
          redirect_to(:action => 'show', :id => @post)
        }
      end
    else
      respond_to do |format|
        format.html { render :action => 'show',        :status => :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.html {
        render :partial => 'post', :locals => {:post => @post} if request.xhr?
      }
    end
  end

  def new
    @post = Post.new
  end

  def preview
    @post = Post.build_for_preview(params[:post])

    respond_to do |format|
      format.js {
        render :partial => 'post', :locals => {:post => @post}
      }
    end
  end

  def destroy
    undo_item = @post.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = I18n::t('flash.post_deleted', :title => @post.title)
        redirect_to :action => 'index'
      end
      format.json {
        render :json => {
          :undo_path    => undo_admin_undo_item_path(undo_item),
          :undo_message => undo_item.description,
          :post         => @post
        }.to_json
      }
    end
  end

  def update_tag
    @tag = Tag.find(params[:id])
    success = @tag.update_attributes( :name => params[:name] )
    render :nothing => success
  end

  protected

  def find_post
    @post = Post.find(params[:id])
  end

end


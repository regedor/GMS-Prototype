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
    config.nested.add_link(I18n::t("admin.posts.index.comments_link"), [:comments])

    Scaffoldapp::active_scaffold config, "admin.posts", [
      :title,:excert,:published_at,:total_approved_comments
    ]

  end

  def index
    @tags = Tag.paginate :page => params[:tag_page],
                         :per_page => 5,
                         :conditions => 'taggings_count > 0',
                         :order => 'taggings_count DESC'
    super
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      respond_to do |format|
        format.html {
          flash[:notice] = "Created post '#{@post.title}'"
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
          flash[:notice] = "Updated post '#{@post.title}'"
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
        render :partial => 'preview', :locals => {:post => @post}
      }
    end
  end

  def destroy
    undo_item = @post.destroy_with_undo

    respond_to do |format|
      format.html do
        flash[:notice] = "Deleted post '#{@post.title}'"
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


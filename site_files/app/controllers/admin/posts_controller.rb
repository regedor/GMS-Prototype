class Admin::PostsController < Admin::BaseController
  before_filter :find_post,                 :only => [ :show, :update, :destroy ]
  before_filter :tags_in_instance_variable, :only => [ :list, :index ]
  before_filter :list_tags,                 :only =>   :index 

  active_scaffold :post do |config|
    Scaffoldapp::active_scaffold config, "admin.posts",
      :list   => [ :title, :excert, :published_at, :total_approved_comments ],
      :create => [  ],
      :edit   => [  ]
  end

  def custom_finder_options
    return Post.tags_filter @tag_ids
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      respond_to do |format|
        format.html {
          flash[:notice] = I18n::t('active_scaffold.created_model', :model => "post #{@post.title}")
          redirect_to(:action => 'edit', :id => @post)
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
          flash[:notice] = I18n::t('active_scaffold.updated_model', :model => "post #{@post.title}")
          redirect_to(:action => 'edit', :id => @post)
        }
      end
    else
      respond_to do |format|
        format.html { render :action => 'show',        :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.comments.each { |comment| comment.destroy }
    @post.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = I18n::t('active_scaffold.deleted_model', :model => "post #{@post.title}")
        redirect_to(:action => 'index')
      }
    end
  end

  def edit
    @post = Post.find params[:id]
  end

  def new
    @post = Post.new
  end

  def preview
    @post = Post.build_for_preview(params[:post])

    respond_to do |format|
      format.js {
        render :partial => 'posts/post', :locals => {:post => @post}
      }
    end
  end

  def edit_tag
    @tag = Tag.find(params[:id])
  end

  def update_tag
    @tag = Tag.find(params[:id])
    old_name = @tag.name
    new_name = params[:tag][:name]
    success = @tag.update_attributes params[:tag]
    if success
      flash[:notice] = I18n::t('flash.tag_changed', :old => old_name, :new => new_name)
    else
      flash[:error] = I18n::t('flash.invalid_tag_change', :old => old_name, :new => new_name)
    end

    respond_to do |format|
      format.html {
          redirect_to :action => :index
      }
      format.js {
        render :update do |page|
          page.replace_html "flash", flash_messages
          page.call 'update_record', @tag.id, old_name, new_name if success
        end
      }
    end
  end

  protected

    def tags_in_instance_variable
      @tag_ids = params[:tag_ids] ? params[:tag_ids].split(",") : []
    end
  
    def list_tags
      @tags = Tag.paginate_filtered_tags @tag_ids, params[:tag_page]
    end
  
    def find_post
      @post = Post.find(params[:id])
    end

end


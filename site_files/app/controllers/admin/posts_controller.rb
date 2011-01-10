class Admin::PostsController < Admin::BaseController
  before_filter :tags_in_instance_variable, :only => [ :list, :index ]
  before_filter :list_tags,                 :only =>   :index 

  active_scaffold :post do |config|
    Scaffoldapp::active_scaffold config, "admin.posts",
      :list   => [ :title, :excert, :published_at, :total_approved_comments ],
      :create => [ :title, :body, :tag_list, :published_at_natural, :slug ],
      :edit   => [  ]
  end

  def custom_finder_options
    return Post.tags_filter @tag_ids
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
  
end


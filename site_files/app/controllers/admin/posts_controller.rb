class Admin::PostsController < Admin::BaseController
  filter_access_to :download, :require => :read
  filter_access_to :all, :require => write_as_privilege
  filter_access_to [:index,:show], :require => [:as_read]
  cache_sweeper :post_sweeper, :only => [:update,:create,:destroy]
  before_filter :tags_in_instance_variable, :only => [ :list, :index ]
  before_filter :list_tags,                 :only =>   :index
  before_filter :date_localization,         :only => [ :create, :update, :preview ]

  include ActionView::Helpers::TextHelper

  active_scaffold :post do |config|
    config.list.sorting = {:published_at => :desc}
    Scaffoldapp::active_scaffold config, "admin.posts",
      :list   => [ :title, :excert, :published_at, :total_approved_comments ],
      :show   => [ ],
      :create => [ :title, :body, :tag_list, :published_at, :slug, :image, :image_delete, :generic_delete, :groups ],
      :edit   => [  ]
  end

  def custom_finder_options
    return Post.tags_filter @tag_ids
  end

  def conditions_for_collection
    "event_id is NULL"
  end

  # Overrided this action to show revertion previews and revert option
  def show
    if params[:history_entry_id]
      @actual_record = Post.find params[:id]
      @history_entry = HistoryEntry.find(params[:history_entry_id])
      @record        = @history_entry.historicable_preview
      render :action => 'show'
    else
      super
    end
  end

  def destroy
    post = Post.find(params[:id])
    if post.destroy
      flash[:notice] = t("flash.post_deleted",:post => post.title)
    else
      flash[:error] = t("flash.post_deletion_fail",:post => post.title)
    end
    
    redirect_to admin_posts_path
  end

  def edit
    @record = Post.find(params[:id])

    render :action => :update
  end

  def update
    @record = Post.find(params[:id])
    @record.image.clear if @record.image && params[:record][:image]
    @record.generic.clear if @record.generic && params[:record][:generic]
    if @record.update_attributes params[:record]
      flash[:notice] = t('flash.postUpdated.successfully', :name => @record.title)
      redirect_to admin_posts_path
    else
      @template.properly_show_errors @record
      flash.now[:error] = t('flash.postUpdated.error')
    end
  end

  def create
    @record = Post.new params[:record]
    if @record.save
      flash[:notice] = t('flash.postCreated.successfully', :name => @record.title)
      redirect_to admin_posts_path
    else
      @template.properly_show_errors @record
      flash.now[:error] = t('flash.postCreated.error')
    end
  end

  # Hack for the post preview in the show action
  def do_show
    super
    @post = @actual_record || @record
  end

  def preview
    @post = Post.build_for_preview(params[:record])

    respond_to do |format|
      format.js {
        render :partial => 'preview', :locals => {:post => @post}
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

  def download
    post = Post.find(params[:id])

    send_file post.generic.path, :type=>post.generic_content_type#, :x_sendfile=>true
    # check this before use http://www.therailsway.com/2009/2/22/file-downloads-done-right
  end

  protected

    def tags_in_instance_variable
      @tag_ids = params[:tag_ids] ? params[:tag_ids].split(",") : []
    end

    def list_tags
      @tags = Tag.paginate_filtered_tags @tag_ids, params[:tag_page]
    end

    def date_localization
      begin
        params[:record][:published_at] = DateTime.strptime(params[:record][:published_at],"%d/%m/%Y %H:%M").to_time
      rescue ArgumentError
        flash[:error] = t("flash.invalid_date")
        redirect_to :action => params[:action] == 'create' ? 'new' : 'edit'
        return
      end
    end

end

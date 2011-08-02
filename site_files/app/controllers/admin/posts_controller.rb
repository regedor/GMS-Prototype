class Admin::PostsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  before_filter :tags_in_instance_variable, :only => [ :list, :index ]
  before_filter :list_tags,                 :only =>   :index
  before_filter :date_localization,         :only => [ :create, :update, :preview ]
  before_filter :normalize_groups,          :only => [ :create, :update ]

  include ActionView::Helpers::TextHelper

  active_scaffold :post do |config|
    config.list.sorting = {:published_at => :desc}
    Scaffoldapp::active_scaffold config, "admin.posts",
      :list   => [ :title, :excert, :published_at, :total_approved_comments ],
      :show   => [ ],
      :create => [ :title, :body, :tag_list, :published_at, :slug, :image, :image_delete, :generic_delete, :groups ],
      :edit   => [  ]
  end

  def values
    vals = []
    Group.relevant(params[:q]).each do |group|
      vals << {:id => "#{group.id}", :name => "#{@template.image_tag @template.avatar_url(group,:size => :small)} #{group.name}" }
    end
    
    respond_to do |format|
      format.json { render :json => vals.to_json }
    end
  end

  def pre_populate
    vals = []
    Post.find(params[:id]).groups.each do |group|
      vals << {:id => "#{group.id}", :name => "#{group.name}" }
    end

    respond_to do |format|
      format.json { render :json => vals.to_json }
    end
  end

  def normalize_groups
    unless params[:record][:groups].empty?
      normalized_groups = params[:record][:groups].split(',').reject(&:blank?)
      params[:record][:groups] = normalized_groups
    else
      params[:record][:groups] = []
    end
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

  def edit
    @record = Post.find(params[:id])
    
    render :action => :update 
  end  

  def update
    post = Post.find(params[:id])
    post.update_attributes params[:record]
    if post.save
      flash[:notice] = t('flash.postUpdated.successfully', :name => post.title)
    else
      flash[:error] = t('flash.postUpdated.error')
    end
    redirect_to admin_posts_path
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

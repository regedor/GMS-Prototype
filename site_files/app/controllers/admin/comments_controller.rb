class Admin::CommentsController < Admin::BaseController
  filter_access_to :all, :require => write_as_privilege
  filter_access_to [:index,:show], :require => [:as_read]
  before_filter :calculate_commentable_and_title, :only => [ :index, :list ]

  active_scaffold :comments do |config|
    Scaffoldapp::active_scaffold config, "admin.comments", 
      :list         => [ :commenter, :excert, :created_at ], 
      :edit         => [ :body ]
  end

  # Override this method to define conditions to be used when querying a recordset (e.g. for List).
  def conditions_for_collection
    if @commentable_type
      return { :commentable_type => @commentable_type,
               :commentable_id =>   @commentable_id  }
    else
      return { }
    end
  end

  protected

    def calculate_commentable_and_title
      params.each do |k,v|
        if k =~ /.*_id/
          ctype = k.chomp('_id').capitalize
          if ['Post', 'Page'].member? ctype
            @commentable_type = ctype
            @commentable_id = v
            case ctype
              when 'Post'
                @commentable = Post.find v
              when 'Page'
                @commentable = Page.find v
            end
            active_scaffold_config.list.label = I18n::t 'admin.comments.index.title', :title => @commentable.title
          end
        end
      end
    end

end

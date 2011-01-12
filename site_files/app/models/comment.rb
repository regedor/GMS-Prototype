class Comment < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  belongs_to            :commentable, :polymorphic => true
  belongs_to            :user

  before_save           :apply_filter
  after_save            :denormalize
  after_destroy         :denormalize

  validates_presence_of :user_id, :body, :commentable

  ##FIXME Authorization to comment
  def authorized_for?(*args)
    #!deleted
    true
  end

  # Sets body_html formatting body as html.
  def apply_filter
    self.body_html = Lesstile.format_as_xhtml(self.body, :code_formatter => Lesstile::CodeRayFormatter)
  end

  def trusted_user?
    false
  end

  def user_logged_in?
    false
  end

  def approved?
    true
  end

  def denormalize
    self.commentable.update_attribute :approved_comments_count,
                                      Comment.all( :select     =>   'COUNT(*) as count',
                                                   :conditions => { :commentable_type => self.commentable_type,
                                                                    :commentable_id   => self.commentable_id  }
                                                 ).first.count
  end

  def to_s
    "#{author} (#{id})"
  end

  # Delegates
  def author
    user.nickname_or_first_and_last_name
  end

  class << self
    def protected_attribute?(attribute)
      [:author, :body].include?(attribute.to_sym)
    end

    # Creates new comment with filter
    def new_with_filter(params)
      comment = Comment.new(params)
      comment.created_at = Time.now
      comment.apply_filter
      comment
    end

    # Builds preview from params
    def build_for_preview(params)
      comment = Comment.new_with_filter(params)
      if comment.requires_openid_authentication?
        comment.author_url = comment.author
        comment.author     = "Your OpenID Name"
      end
      comment
    end

    # Finds recent comments 
    def find_recent(options = {})
      find(:all, {
        :limit => DEFAULT_LIMIT,
        :order => 'created_at DESC'
      }.merge(options))
    end
  end
end

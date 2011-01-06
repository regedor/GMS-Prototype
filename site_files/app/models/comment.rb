class Comment < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  attr_accessor         :openid_error
  attr_accessor         :openid_valid

  belongs_to            :post

  before_save           :apply_filter
  after_save            :denormalize
  after_destroy         :denormalize

  validates_presence_of :author, :body, :post

  #named_scope :not_deleted, :conditions => {:deleted => false}

  # validate :open_id_thing
  def validate
    super
    errors.add(:base, openid_error) unless openid_error.blank?
  end

  ##FIXME Authorization to comment
  def authorized_for?(*args)
    #!deleted
    true
  end

  #FIXME Comments don't have deleted field
  def destroy
    self.deleted = true
    self.post.approved_comments
    self.save
  end

  # # Sets body_html formatting body as html.
  def apply_filter
    self.body_html = Lesstile.format_as_xhtml(self.body, :code_formatter => Lesstile::CodeRayFormatter)
  end

  # Erases author and author's email fields
  def blank_openid_fields
    self.author_url = ""
    self.author_email = ""
  end

  # Checks if OpenID is required
  def requires_openid_authentication?
    !!self.author.index(".")
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
    self.post.denormalize_comments_count!
  end

  #def destroy_with_undo
  #  undo_item = nil
  #  transaction do
  #    self.destroy
  #    undo_item = DeleteCommentUndo.create_undo(self)
  #  end
  #  undo_item
  #end

  def to_s
    "#{author} (#{id})"
  end

  # Delegates
  def post_title
    post.title
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

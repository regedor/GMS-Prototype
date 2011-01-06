class CommentActivity
  attr_accessor :post

  # Initialize CommentActivity for a given post
  def initialize(post)
    self.post = post
  end

  # Returns the 5 most recent comments
  def comments
    @comments ||= post.approved_comments.find_recent(:limit => 5)
  end

  # Returns the most recent comment
  def most_recent_comment
    comments.first
  end

  class << self
    # Returns the 5 most recent comments
    def find_recent
      Post.find(:all,
        :group  => "comments.post_id, posts." + Post.column_names.join(", posts."),
        :select => 'posts.*, max(comments.created_at), comments.post_id',
        :joins  => 'INNER JOIN comments ON comments.post_id = posts.id',
        :order  => 'max(comments.created_at) desc',
        :limit  => 5
      ).collect {|post|
        CommentActivity.new(post)
      }.sort_by {|activity|
        activity.most_recent_comment.created_at
      }.reverse
    end
  end
end

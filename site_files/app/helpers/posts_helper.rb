module PostsHelper

  # This isn't strictly correct, but it's a pretty good guess
  # and saves another hit to the DB
  def more_content?
    @posts.size == Post::DEFAULT_LIMIT
  end

  def format_comment_error(error)
    {
      'body'    => 'Please comment',
      'user_id' => 'You must be logged in to comment',
      'base'    => error.last
    }[error.first]
  end

end

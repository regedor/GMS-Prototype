module PostsHelper

  def format_comment_error(error)
    {
      'body'    => 'Please comment',
      'user_id' => 'You must be logged in to comment',
      'base'    => error.last
    }[error.first]
  end

end

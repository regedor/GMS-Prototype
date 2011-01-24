module CommentsHelper

  def format_comment_error
    message = I18n::t('comments.error.generic')
    case @comment.errors.first.first
      when 'body' then
        message += ' ' + I18n::t('comments.error.no_body')
      when 'user_id' then
        message += ' ' + I18n::t('comments.error.no_login')
    end

    return message
  end

end

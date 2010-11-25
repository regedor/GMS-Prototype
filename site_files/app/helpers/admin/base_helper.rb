module Admin::BaseHelper

  def role_column(user)
    t("users.roles." + user.role_sym.to_s)
  end

  def row_mark_column(record)
    '<input id="row_mark_' + record.id.to_s + '" name="list" class="row_mark_elem" type="checkbox"\>'
  end

  def excert_column(record)
    tmpc = h(truncate(record.body, :length => 55)) 
    tmpc != '' ? tmpc : '&nbsp;'
  end

  def commenter_column(comment)
    h comment.author
  end

  def total_approved_comments_column(post)
    post.approved_comments.size
  end

  def created_at_column(record)
    record.created_at.strftime('%d %b, %Y')
  end

  def published_at_column(record)
    record.published_at.strftime('%d %b, %Y')
  end
  
  def type_column(action)
    action.complete_description
  end  

end

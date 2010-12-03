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
  
  def controller_column(record)
    record.controller.split("/").last.singularize.capitalize_first
  end  
  
  def users_performed_on_column(record)
   #if record.controller == "admin/users"
   #  #Gets the ids for the users
   #  match = record.message[/Performed on ids: \[(.*)\]/]
   #  value = $1
   #
   #  #Transforms the string with ids into an array
   #  ids = value.split(/\"/).map(&:to_i).map(&:nonzero?).compact!
   #end
   #
   #names = []
   #ids.each do |id|
   #  names << User.find(id).name
   #end   
   # 
   # names.join(", ")
   Hash.from_xml(record.undo)["user"]["name"]
  end  

end

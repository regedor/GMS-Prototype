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
    comments = post.approved_comments.size
    message = I18n::t('admin.posts.index.comments_link.' + ((comments == 1) ? 'one' : 'more'), :count => comments)
    if comments > 0
      link_to(message, admin_post_comments_path(post))
    else
      message
    end
  end
  
  def created_at_column(record)
<<<<<<< HEAD
    if (Time.now - record.created_at) < 30.days
      time_ago_in_words record.created_at 
    else
      record.created_at.strftime('%d %b, %Y')
    end
  end
=======
    record.created_at.strftime('%d %b, %Y')
  end  
>>>>>>> origin/features/admin-actions

  def published_at_column(record)
    if (Time.now - record.published_at) < 30.days
      time_ago_in_words record.published_at 
    else
      record.published_at.strftime('%d %b, %Y')
    end
  end
  
  def type_column(action)
    action.complete_description
<<<<<<< HEAD
  end

  # Generates html containing the flash messages with the correct classes.
  def flash_messages
    code = ""
    flash.each do |type, message|
      next if message.nil?
      code += "<div class=\"message #{type}\">\n"
      code += "  <p>#{message}</p>\n"
      code += "</div>\n"
    end

    code
  end

  # Auxiliar method that checks if some controller is the current controller.
  # Needed to differentiate the current controller for highlight in the navigation bar.
  def is_menu_active? controller_paths
    active = false
    controller_paths.each do |path|
      next if active
      active = controller.controller_path == path
    end

    active
  end

  # Prints one element of the navigation menu.
  def navigation_menu(i18n_path, controller_paths, link_to_path, options={})
    code = '<li class="'
    code += 'active ' if is_menu_active? controller_paths
    code += 'first ' if options[:first]
    code += "\">\n"
    code += link_to(I18n::t(i18n_path), link_to_path) + "\n"
    code += "</li>\n"

    code
  end

  # Checks if the argument navigation bar is the one to be shown.
  # If it is then it's shown.
  def secondary_navigation_menu(active_links, options={})
    code = ""
    if is_menu_active? active_links.map { |hash| hash[:controller_paths] }.flatten
      first = true if options[:specify_first] #filter nil
      active_links.each do |hash|
        code += navigation_menu hash[:i18n_path], hash[:controller_paths], hash[:link_to_path], :first => first
        first = false
      end
    end

    code
  end
=======
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
>>>>>>> origin/features/admin-actions

end

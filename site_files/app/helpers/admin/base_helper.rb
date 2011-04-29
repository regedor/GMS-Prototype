module Admin::BaseHelper

  def title_column(record)
    return case record.class.to_s
      when 'Post' then
        link_to(record.title, post_path(record))
      when 'Page' then
        link_to(record.title, page_path(record))
      when 'Event' then
        link_to(record.title, event_path(record))
      when 'EventActivity' then
        link_to(record.title, event_event_activity_path(record.event_id,record))
      else
        record.title
    end
  end

  def user_id_show_column(record)
    User.find(record.user_id).to_label
  end 
  
  def xml_groups_and_users_show_column(record)
    final_str = ""
    Hash.from_xml(record.xml_groups_and_users)['entities'].each do |k,v|
      case k
        when "group" then final_str += v['name'] + I18n::t("admin.mails.group")+", "
        when "user"  then final_str += "#{v['name']} < #{v['email']} >, "
      end       
    end  
    final_str.chop!.chop!
    #record.xml_groups_and_users.inspect
    #"<cenas>valor</cenas>"
    #Hash.from_xml(record.xml_groups_and_users)['entities']
  end

  def sent_on_column(record)
    if (Time.now - record.sent_on) < 30.days
      I18n::t "generic_sentence.time_ago", :time_ago => time_ago_in_words(record.sent_on)
    else
      record.sent_on.strftime('%d %b, %Y')
    end
  end  
  
  def message_column(record)
    truncate(record.message,50,"...")
  end  

  def role_column(user)
    t("users.roles." + user.role.label)
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

  def total_approved_comments_column(commentable)
    comments = commentable.approved_comments_count
    message = I18n::t('admin.posts.index.comments_link.' + ((comments == 1) ? 'one' : 'more'), :count => comments)
    if comments > 0
      link_to(message, send("admin_#{commentable.class.to_s.downcase}_comments_path", commentable))
    else
      message
    end
  end

  def starts_at_column(record)
    if record.starts_at == record.starts_at.at_beginning_of_day
      record.starts_at.strftime('%d/%m/%Y')
    else
      record.starts_at.strftime('%d/%m/%Y %H:%M')
    end
  end

  def ends_at_column(record)
    if record.ends_at == record.ends_at.at_beginning_of_day
      record.ends_at.strftime('%d/%m/%Y')
    else
      record.ends_at.strftime('%d/%m/%Y %H:%M')
    end
  end
  
  def created_at_column(record)
    if (Time.now - record.created_at) < 30.days
      I18n::t "generic_sentence.time_ago", :time_ago => time_ago_in_words(record.created_at)
    else
      record.created_at.strftime('%d %b, %Y')
    end
  end

  def published_at_column(record)
    if (Time.now - record.published_at) < 30.days
      time_ago_in_words record.published_at 
    else
      record.published_at.strftime('%d %b, %Y')
    end
  end
  
  def type_column(action)
    action.complete_description
  end
  
  def active_column(record)
    if record.active
      '<p class = "tick">'+I18n::t('generic_sentence.true_value')+'</p>'
    else
      '<p class = "cross">'+I18n::t("generic_sentence.false_value")+'</p>'
    end
  end
  
  def mailable_column(record)
    if record.mailable
      '<p class = "tick">'+I18n::t('generic_sentence.true_value')+'</p>'
    else
      '<p class = "cross">'+I18n::t("generic_sentence.false_value")+'</p>'
    end  
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
  
end

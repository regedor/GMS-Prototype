module ApplicationHelper
 	include TweetButton

  def icon_tag(icon)
    "<img src='/images/icons/#{icon}.png' alt=''/>"
  end

  def flag_tag(icon)
    "<img src='/images/flags/#{icon}.png' alt='#{icon}'/>"
  end

  def language_flag_tag(language)
    icon = case language
      when 'en'    : "gb"
      when 'pt-PT' : "pt"
    end
    "<img src='/images/flags/#{icon}.png' alt=''/>"
  end

  def select_language_collection
    UserSession::LANGUAGES
  end
  
  def avatar_url(record, options={})
    options[:size] ||= :medium
    raise "Invalid arguments" unless [:small,:medium].member? options[:size]
    if record.nil?
      options[:size]   = 100 if options[:size] == :medium
      options[:size]   = 50  if options[:size] == :small
      return "#{root_url}images/deleted-user-#{options[:size]}.png"
    elsif record.avatar.path.nil?
      options[:size]   = 100 if options[:size] == :medium
      options[:size]   = 50  if options[:size] == :small
      default_url    ||= options[:default_url] || "#{root_url}images/guest-#{options[:size]}.png"
      gravatar_id      = Digest::MD5.hexdigest(record.email.downcase)
      return "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{options[:size]}&d=#{CGI.escape(default_url)}"
    else
      return record.avatar.url(options[:size])
    end
  end

  def file_icon_displayer(file)
    if file.content_type =~ /^image\//
      return file.url(:thumb)
    else
      return "#{root_url}images/icons/door.png"
    end    
  end  

  def include_i18n_calendar_javascript
    content_for :head do
     javascript_include_tag case I18n.locale.to_s
        when 'en'    then "jquery.ui.datepicker-en-GB.js"
        when 'pt-PT' then "jquery.ui.datepicker-pt-BR.js"
        else raise ArgumentError, "Locale error"
      end
    end
    content_for :head do
      javascript_include_tag "jquery-ui-timepicker-addon.js"
    end
  end

  def render_date(time)
    if (Time.now - time) < 30.days
      I18n::t "generic_sentence.time_ago", :time_ago => time_ago_in_words(time)
    else
      record.starts_at.strftime('%d %b, %Y')
    end
  end

end

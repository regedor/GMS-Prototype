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
    options[:size] ||= 100
    default_url    ||= options[:default_url] || "#{root_url}images/guest-#{options[:size]}.png"
    gravatar_id      = Digest::MD5.hexdigest(record.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{options[:size]}&d=#{CGI.escape(default_url)}"
  end

  def include_i18n_calendar_javascript
    content_for :head do
     javascript_include_tag case I18n.locale
        when :en then "jquery.ui.datepicker-en-GB.js"
        when :pt then "jquery.ui.datepicker-pt-BR.js"
        else raise ArgumentError, "Locale error"
      end
    end
  end

end

class Formtastic::SemanticFormBuilder 
  def button(*args)
    options = args.extract_options!
    text = options.delete(:label) || args.shift

      if @object && @object.respond_to?(:new_record?)
        key = @object.new_record? ? :create : :update
        object_name = @object.class.name.underscore.humanize 
      else
        key = :submit
        object_name = @object_name.to_s.send(@@label_str_method)
      end
 
      text = (self.localized_string(key, text, :action, :model => object_name) ||
              ::Formtastic::I18n.t(key, :model => object_name)) unless text.is_a?(::String)
 
      button_html = options.delete(:button_html) || {}
      button_html.merge!(:class => [button_html[:class], key].compact.join(' '))
      button_html.merge!(:type => [button_html[:type], key].compact.join(' '))
      element_class = ['commit', options.delete(:class)].compact.join(' ')
      accesskey = (options.delete(:accesskey) || @@default_commit_button_accesskey) unless button_html.has_key?(:accesskey)
      button_html = button_html.merge(:accesskey => accesskey) if accesskey

    button="<button #{tag_options(button_html.stringify_keys, true)}>#{text}</button>"
    template.content_tag(:li, button, :class => element_class)
  end

  def button_link(*args)
    options = args.extract_options!
    text = args.shift
    href = args.shift

      if @object && @object.respond_to?(:new_record?)
        key = @object.new_record? ? :create : :update
      else
        key = :submit
      end
 
      button_html = options.delete(:button_html) || {}
      button_html.merge!(:class => [button_html[:class], key].compact.join(' '))
      accesskey = (options.delete(:accesskey) || @@default_commit_button_accesskey) unless button_html.has_key?(:accesskey)
      button_html = button_html.merge(:accesskey => accesskey) if accesskey

    element_class = ['commit', options.delete(:class)].compact.join(' ') 

    button_link = "<a href='#{href}' #{tag_options(button_html.stringify_keys, true)}>#{text}</a>"
    template.content_tag(:li, button_link, :class => element_class)
  end

 private

  def tag_options(options, escape = true)
    unless options.blank?
      attrs = []
      if escape
        options.each do |key, value|
          next unless value
          key = key.to_s
          value = Set.new(%w(disabled readonly multiple)).include?(key) ? key : escape_once(value)
          attrs << %(#{key}="#{value}")
        end
      else
        attrs = options.map { |key, value| %(#{key}="#{value}") }
      end
      " #{attrs.sort * ' '}" unless attrs.empty?
    end
  end

  def escape_once(html)
    html.to_s.gsub(/[\"><]|&(?!([a-zA-Z]+|(#\d+));)/) { |special| ERB::Util::HTML_ESCAPE[special] }
  end

end

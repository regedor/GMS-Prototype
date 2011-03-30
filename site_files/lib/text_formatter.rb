require 'RedCloth'
class TextFormatter

     def self.format_as_xhtml(text)
       Lesstile.format_as_xhtml(
         text,
         :text_formatter => lambda {|text| RedCloth.new(CGI::unescapeHTML(text)).to_html},
         :code_formatter => Lesstile::CodeRayFormatter
       )
     end

    def self.format_as_xhtml_with_excerpt(text)
      response = { }
      if response[:splitted] = (text =~ /.*__EOP__.*/) != nil
        parts = text.split '__EOP__'
        excerpt = parts[0]
        body = parts.join ''
      else
        excerpt = text
        body = text
      end
      response[:excerpt] = Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda {|text| RedCloth.new(CGI::unescapeHTML(excerpt)).to_html},
        :code_formatter => Lesstile::CodeRayFormatter
      )
      response[:body] = Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda {|text| RedCloth.new(CGI::unescapeHTML(body)).to_html},
        :code_formatter => Lesstile::CodeRayFormatter
      )
      return response
    end

end

module RedCloth::Formatters::HTML
  include UrlHelper

  def link(opts)
    base_link = escape_attribute opts[:href]
    link_parts = base_link.split(/:/, 2)
    if [ 'page', 'post' ].member? link_parts[0]
      link = (link_parts.length == 2) ? send("#{link_parts[0]}_path", eval(link_parts[0].capitalize).find_by_slug(link_parts[1])) : base_link
    else
      link = base_link
    end
    "<a href=\"#{link}\"#{pba(opts)}>#{opts[:name]}</a>"
  end

end

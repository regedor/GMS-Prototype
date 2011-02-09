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
      if response[:splitted] = (text =~ /.*-BREAK-.*/) != nil
        parts = text.split '-BREAK-'
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

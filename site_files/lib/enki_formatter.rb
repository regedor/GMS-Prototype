require 'RedCloth'
class EnkiFormatter

    def self.format_as_xhtml(text)
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda {|text| RedCloth.new(CGI::unescapeHTML(text)).to_html},
        :code_formatter => Lesstile::CodeRayFormatter
      )
    end

end

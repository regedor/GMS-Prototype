class String
  # Capitalizes only the first character of a string (unlike "string".capitalize), leaving the rest
  # untouched.  spinach => Spinach, CD => CD, cat => Cat, crAzY => CrAzY
  def capitalize_first
  	string = self[0,1].capitalize + self[1, self.length]
  	return string
  end
  
  # Capitalizes the first character of all words not found in words_to_skip_capitalization_of()
  # Examples of skipped words include 'of', 'the', 'or', etc.  Also capitalizes the first character
  # of the string regardless.
  def capitalize_most_words
  	self.split.collect{ |w| words_to_skip_capitalization_of.include?(w.downcase) ? w : w.capitalize_first }.join(" ").capitalize_first
  end
  
  # Capitalizes the first character of all words in string
  def capitalize_words
  	self.split.collect{ |s| s.capitalize_first }.join(" ")
  end
  
  # Applies RedCloth/Textile formatting to the string
  def textilize
  	unless self.blank?
  	  RedCloth.new(self, [:filter_styles, :no_span_caps]).to_html
  	else
  	  ""
    end
  end
  
  def safe_textilize
    return RedCloth.new(self.strip_html, [:filter_styles, :no_span_caps]).to_html
  end
  
  # Applies RedCloth/Textile formatting to the string, and removes the wrapping paragraphs
  def textilize_without_paragraphs
  	unless self.nil? or self.empty?
  	  string = self.textilize
  	  string = string[3..-1]
  	  string = string[0..-5]
  	else
  	  ""
    end
  end
  
  # If a string is longer than 'length', returns the string shortened to length, with 'suffix'
  # appended.  Otherwise, returns the string untouched.  Default suffix of '&#8230;' (three horizontal 
  # elipses) is provided.
  def shorten(length, suffix="&#8230;")
  	if self.length > length-1
  		self.slice(0..length-1) + suffix
  	else
  		self
  	end
  end
  
  # Converts a post title to its-title-using-dashes
  # All special chars are stripped in the process  
  # (partially lifted from Typo (MIT licensed))
  def slugorize
    result = self.downcase
    result.gsub!(/&(\d)+;/, '') # Ditch Entities
    result.gsub!('&', 'and')    # Replace & with 'and'
    result.gsub!(/['"]/, '')    # replace quotes by nothing
    result.gsub!(/\W/, ' ')     # strip all non word chars
    result.gsub!(/\ +/, '-')    # replace all white space sections with a dash
    result.gsub!(/(-)$/, '')    # trim dashes
    result.gsub!(/^(-)/, '')    # trim dashes
    result
  end
  
  def slugorize!
    self.replace(self.slugorize)
  end
     
  def strip_html
    if self.index("<")
      result = ""
      tokenizer = HTML::Tokenizer.new(self)
      while token = tokenizer.next
        node = HTML::Node.parse(nil, 0, 0, token, false)
        # result is only the content of any Text nodes
        result << node.to_s if node.class == HTML::Text  
      end
      # strip any comments, and if they have a newline at the end (ie. line with
      # only a comment) strip that too
      result.gsub!(/<!--(.*?)-->[\n]?/m, "") 
      return result
    else
      return self # already plain text
    end
  end

 private

  # Defines an array of words to which capitalize_most_words() should skip over.
  # TODO: Should "it" be included in the list?
  def words_to_skip_capitalization_of
    [ 
      'of','a','the','and','an','or','nor','but','if','then','else','when','up','at','from','by','on',
      'off','for','in','out','over','to'
    ]
  end	

end



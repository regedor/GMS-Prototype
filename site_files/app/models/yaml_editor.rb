class YamlEditor

  attr_accessor :filename, :file_hash, :options_hash

  # ==========================================================================
  # Relationships
  # ==========================================================================

  # ==========================================================================
  # Validations
  # ==========================================================================

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  # Loads a YAML file
  def initialize(options_hash={})
    @global_title = options_hash.delete 'yaml_editor_title'
    @filename = options_hash.keys.first
    @file_hash = YAML::load_file(filename)
    @options_hash = options_hash.values.first
    @final_hash   = {}
    @all_values   = {} 
    @path         = []
  end

  def update_attributes(params=[])
    keys = @options_hash.keys
    
    params.each do |key,value|
      set_value_from_path(key,value) if keys.member? key
    end
    p keys
  end  

  # Saves a hash as YAML in  the file in filename
  def save
    file_str = YAML::dump @file_hash
    File.open(@filename, 'w') {|f| f.write(file_str)}
  end

  # Returns the inline string to be rendered by the controller
  def render
    str = "<% form_tag({:controller => \"settings\", :action => \"update\", :id=>1}, :method => \"put\") do %>"
    
    if @options_hash == :all
      get_all_values_nested.each_pair do |k,v|
        str += "<br/><br/>#{k.split(".").last}: " 
    	  str += "<input name=#{k} type=\"text\" value=#{v} />"
      end  
    else
      @options_hash.keys.each do |path|
        #str += "<p><label>#{path}</label></p><br/>"	
        str += "#{self.options_hash[path]['title']}: " 
    	  str += self.get_value_from_path(path)
    	end  
    end

    str += "<p><input id=\"person_submit\" name=\"commit\" type=\"submit\" value=\"Save Changes\" /></p>\n<% end -%>"
    
    return str
  end  

  # Given a path (eg: "development.theme") and a newValue, sets the value in that path from the file_hash
  def set_value_from_path(path_to_value,newValue)
    path_array = path_to_value.split "."
    last_key = path_array.pop
    hash = create_hash_with_path(path_array,{last_key=>newValue})
    self.merge!(@file_hash,hash)
  end  

  # Given a path (eg: "development.theme"), gets the value in that path from the file_hash and returns the HTML code corresponding 
  # to what  was asked for that value, in the options_hash
  def get_value_from_path(path_to_value)
    path_array = path_to_value.split "."
    current_value = @file_hash
    for i in (0..path_array.size-1)
      current_value = current_value[path_array[i]]
    end 
    
    case @options_hash[path_to_value]['type']
      when "text_field" then return "<input name=#{path_to_value} type=\"text\" value=#{current_value} /></br></br>"
      when "select" then 
        str = "<select name=#{path_to_value}>"
        #str += "<option value=#{current_value}>#{current_value}</option>"
        @options_hash[path_to_value]['options'].each do |key, value|
          str += (value == current_value ? "<option value=#{key} selected>#{value}</option>" : "<option value=#{key}>#{value}</option>")
        end  
        str+= "</select><br/><br/>"
        return str
      else raise ArgumentError, "Unhandled type #{@options_hash[path_to_value]['type']}"  
    end    
  end  

  # Merges two nested hashes, keeping the values in merge2, inc ase of conflict
  def merge!(merge1,merge2)
    case merge1
      when String then merge2
      else merge1.merge!(merge2) {|key,old_value,new_value| self.merge!(old_value,new_value)} if merge1 && merge2
    end    
  end  

  # Gets all the final values in a nested hash and returns them as an array
  def get_all_values_nested(file_hash=@file_hash)
    
    file_hash.each_pair do |k,v|
      
      @path << k
      case v
        when String then @all_values.merge!({"#{@path.join(".")}" => "#{v}"}) 
          @path.pop
        #when Array  then get_array_values(v,file_hash[k]) if file_hash[k]
        when Hash   then get_all_values_nested(file_hash[k]) if file_hash
        else raise ArgumentError, "Unhandled type #{v.class}"
      end
    end
    @path.pop
    
    return @all_values
  end  


  # Filters nested hashes. Receives the hash of attributes to filter (eg: {"en"=>[{"navigation"=>[{"title"}]}]})
  # returns the file_hash but only with the requested attributes values 
  def get_only_some_attributes(attr_hash,file_hash=@file_hash)
    @final_hash = {}
    attr_hash.each_pair do |k,v|
      @path << k
      case v
        when Array  then get_array_values(v,file_hash[k]) if file_hash[k]
        when Hash   then get_only_some_attributes(v,file_hash[k]) if file_hash
        else raise ArgumentError, "Unhandled type #{v.class}"
      end
    end
    @path.pop
    
    return @final_hash
  end
  
  private 
  
  # Used when an array is found in the nested hash
  def get_array_values(array,file_hash)
    array.each do |value|
      case value
        when String then self.merge!(@final_hash,create_hash_with_path(@path,{value=>file_hash[value]})) if file_hash[value]
        when Hash   then get_only_some_attributes(value,file_hash) if file_hash
        else raise ArgumentError, "Unhandled type #{v.class}"  
      end
    end
    
  end  
  
  # Receives array (eg: ["dev","example"]) and hash (eg: {"theme"=>"simon"}), 
  # and returns a hash (eg: {"dev"=>{"example"=>{"theme"=>simon}}})
  def create_hash_with_path(path_array,hash)
    newHash = Hash.new
    tempHash = Hash.new
    flag = 1
    path_array.reverse.each do |value|
      if flag == 1
        tempHash = hash
        flag = 0
      else
         tempHash = newHash  
      end  
      
      newHash = {value => tempHash}
    end  
    
    return newHash
  end
  

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self

  end
end


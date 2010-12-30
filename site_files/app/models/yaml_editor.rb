class YamlEditor

  attr_accessor :filename, :file_hash, :final_hash, :path

  # ==========================================================================
  # Relationships
  # ==========================================================================

  # ==========================================================================
  # Validations
  # ==========================================================================

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  def initialize
    @file_hash   = {}
    @filename    = ""
    @final_hash  = {}
    @path        = []
    
    self.load('config/locales/en.yml')
    keyset = {"en"=>[{"navigation"=>["title","about"]},{"users"=>{"roles"=>["root"]}}]}
    p self.get_only_some_attributes(keyset)
  end

  def load(filename)
    @filename = filename
    @file_hash = YAML::load_file(filename)
  end

  def save
    file_str = YAML::dump @file_hash
    File.open(@filename, 'w') {|f| f.write(file_str)}
  end

  def merge!(merge1,merge2)
    merge1.merge!(merge2) {|key,old_value,new_value| self.merge!(old_value,new_value)} if merge1 && merge2
  end  

  def get_only_some_attributes(attr_hash,file_hash=@file_hash)
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
  
  def get_array_values(array,file_hash)
    array.each do |value|
      case value
        when String then self.merge!(@final_hash,create_hash_with_path(@path,{value=>file_hash[value]})) if file_hash[value]
        when Hash   then get_only_some_attributes(value,file_hash) if file_hash
        else raise ArgumentError, "Unhandled type #{v.class}"  
      end
    end
    
  end  
  
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


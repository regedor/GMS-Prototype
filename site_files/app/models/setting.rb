class Setting < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  

  # ==========================================================================
  # Validations
  # ==========================================================================



  # ==========================================================================
  # Extra definitions
  # ==========================================================================



  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  def convert_value
    case self.field_type.downcase
      when "integer" then return self.value.to_i
      when "float" then return self.value.to_f
      else return self.value.to_s  
    end  
  end  

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    def load_settings_to_configatron
       Setting.all.each do |setting|     
         configatron.send(setting.identifier+"=",setting.convert_value)
       end 
    end
    
    def add_list_item(item_name,item_link,before_pages=false)
      setting = Setting.find_by_identifier "frontend_navigation"
      item = "<li><a href=\"#{item_link}\">#{item_name}</a></li>"
      if before_pages
        setting.value = item+setting.value
      else
        setting.value += item
      end
      setting.save
      begin; Setting.load_settings_to_configatron; rescue Exception; end
    end
  end

end
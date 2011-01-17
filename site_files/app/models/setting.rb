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
  end

end
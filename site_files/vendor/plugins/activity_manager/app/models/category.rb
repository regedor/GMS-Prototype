class Category < ActiveRecord::Base

  # ==========================================================================
  # Relationships
  # ==========================================================================
  
   has_many :messages

  # ==========================================================================
  # Validations
  # ==========================================================================

  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================

  # ==========================================================================
  # Extra defnitions
  # ==========================================================================


end

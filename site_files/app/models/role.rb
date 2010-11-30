class Role < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  has_and_belongs_to_many :groups
  has_many                :users    , :through => 'groups'


  # ==========================================================================
  # Validations
  # ==========================================================================

  # ==========================================================================
  # Instance Methods
  # ==========================================================================
 
  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
  end

end

class RecipeCategory < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================

  belongs_to :recipe


  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_presence_of :name, :message => I18n::t('flash.cant_be_blank')

  # ==========================================================================
  # Extra defnitions
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
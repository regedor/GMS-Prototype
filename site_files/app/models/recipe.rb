class Recipe < ActiveRecord::Base
  
  # ==========================================================================
  # Relationships
  # ==========================================================================

  belongs_to :recipe_dificulty
  belongs_to :recipe_category
  has_one :image, :dependent => :destroy
  accepts_nested_attributes_for :image, :allow_destroy => true


  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_presence_of :name, :image_id, :recipe_category_id, :publication_date, :message => I18n::t('flash.cant_be_blank')

  # ==========================================================================
  # Extra definitions
  # ==========================================================================

  before_save do |instance|
    instance.image.destroy   if instance.image_delete == "1"
  end
  attr_writer :image_delete


  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  def image_delete ; @image_delete ||= "0" ; end
  

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    
  end
  
end
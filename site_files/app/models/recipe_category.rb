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

  def localize
    I18n::t("admin.recipes.labels.#{self.name.parameterize}")
  end

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    def get_type_id(type_symbol)
    case type_symbol
    when :entrada
      "starter"
    when :prato_principal
      "main-course"
    when :sobremesa
      "dessert"
    else
      raise ArgumentError.new("Wrong argument")
    end
  end
  end
end
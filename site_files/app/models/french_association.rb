class FrenchAssociation < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  belongs_to :department

  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_length_of :postal_code, 
                      :is => 5, 
                      :wrong_length  => I18n::t('associations.validate.wrong_length')
                      
  validates_numericality_of :fax,
                            :only_integer => true,
                            :not_a_number => I18n::t('associations.validate.not_a_number'),
                            :if => "fax.present?"
  
  validates_numericality_of :phone_no,
                            :only_integer => true,
                            :not_a_number => I18n::t('associations.validate.not_a_number'),
                            :if => "phone_no.present?"
                            
  validates_presence_of :name
  
  validates_presence_of :postal_code

  # ==========================================================================
  # Extra defnitions
  # ==========================================================================

  before_save :join_with_department

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  private
  
  def join_with_department
    d = Department.find_by_code self.postal_code[0,2]
    unless d
      errors.add(:postal_code, "Invalid postal code")
      return false
    end
    self.department_id = d.id
  end

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    
  end

end

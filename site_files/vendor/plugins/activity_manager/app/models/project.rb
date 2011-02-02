class Project < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  belongs_to :user
  belongs_to :blackboard
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :users
  has_many :to_do_lists
  has_many :messages

  # ==========================================================================
  # Validations
  # ==========================================================================



  # ==========================================================================
  # Extra defnitions
  # ==========================================================================
 

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  def ordered_lists
    ToDoList.ordered_position(self.id)
  end  

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    
  end

end

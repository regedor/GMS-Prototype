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
    def find_all_for_user(user)
      find_by_sql('SELECT projects.* FROM projects INNER JOIN projects_users ON projects.id = projects_users.project_id WHERE projects_users.user_id = '+user.id.to_s)
    end
    
  end

end

class Project < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  belongs_to :user
  belongs_to :blackboard
  belongs_to :group
  has_many   :to_do_lists
  has_many   :messages
  has_many   :categories

  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_presence_of :name

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
      find_by_sql('SELECT projects.* FROM projects INNER JOIN projects_users ON projects.id = projects_users.project_id WHERE projects_users.user_id = '+user.id.to_s) + Project.all.select { |p| p.user == user}
    end
    
  end

end

class ToDoList < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  acts_as_list
  belongs_to :project
  has_many :to_dos, :order => "finished_date desc"

  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_presence_of :name

  # ==========================================================================
  # Extra defnitions
  # ==========================================================================

  named_scope :ordered_position, lambda{ |id| {:conditions => {:project_id => id}, :order => "position asc"}}

  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  

  def divide_done_todos
    done    = []
    notDone = ToDo.ordered_position_done(self.id)
    self.to_dos.each do |todo|
      done << todo if todo.done?  
    end
    
    return {:done => done, :notDone => notDone}
  end  

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    
  end

end

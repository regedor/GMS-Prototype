class ActionEntry < ActiveRecord::Base
  validates_presence_of :controller,:action
  belongs_to :user
  belongs_to :group, :class_name => "Group", :foreign_key => "user_id"
  
  attr_accessible :controller, :action, :user_id, :message
    
  
  #Defines the opposite action for the action given as parameter
  def set_undo_for (action)
    case action
    when "activate!"
      self.undo = "deactivate!"
    when "deactivate!"
      self.undo = "activate!"
    when "destroy_by_ids"
      self.undo = "revive_by_ids"
    when "revive_by_ids"
      self.undo = "destroy_by_ids"      
    else
      self.undo = action  
    end  
  end  
  
end

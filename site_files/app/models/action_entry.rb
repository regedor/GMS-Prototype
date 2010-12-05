class ActionEntry < ActiveRecord::Base
  validates_presence_of :controller,:action
  belongs_to :user, :class_name => "User", :foreign_key => "entity_id"
  belongs_to :group, :class_name => "Group", :foreign_key => "entity_id"
  
  attr_accessible :controller, :action, :entity_id, :message
  
end

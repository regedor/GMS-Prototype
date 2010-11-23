class ActionEntry < ActiveRecord::Base
  validates_presence_of :controller,:action
  #belongs_to :caller, :class_name=>"ActionEntry", :foreign_key=>"user_id"
  
  attr_accessible :controller, :action, :user_id, :message
  
#def initialize (options={})
#  super()
#
#  self.controller = options[:controller]
#  self.action = options[:action]
#  self.user_id = options[:caller].id
#  self.message = options[:message] || "No message provided"  
#  
#  self
#end  
  
  #Defines the opposite action for the action given as parameter
  def set_undo_for (action)
    case action
    when "activate!"
      self.undo = "deactivate!"
    else
      self.undo = nil  
    end  
  end  
  
end

class Group < ActiveRecord::Base
  belongs_to :parent_group,    :class_name=>"Group", :foreign_key=>"parent_group_id"
  has_many   :subgroups,      :class_name=>"Group", :foreign_key=>"parent_group_id"
  has_and_belongs_to_many :users
  
  def parent
    if self.parent_group.nil?
      return ""
    else
      return self.parent_group.name
    end    
  end  
  
end  
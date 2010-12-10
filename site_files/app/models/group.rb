class Group < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================

  has_and_belongs_to_many :groups,       :association_foreign_key => "include_group_id"
  has_and_belongs_to_many :direct_users, :class_name => "User"


  # ==========================================================================
  # Validations
  # ==========================================================================

  named_scope :not_deleted, :conditions => {:deleted => false}


  # ==========================================================================
  # Instance Methods
  # ==========================================================================
  
  #Returns parent name
  def subgroups_names
    self.subgroups.map(&:name).join ", "
  end

  #Give all users
  def all_users
    self.direct_users | subgroups.map(&:direct_users).flatten
  end
  
  #Retrieves and array containing all subgroups
  def subgroups
    subgroups_tree.flatten[1..-1]
  end

  #FIXME
  def pretty_print
    "Name: #{name}\nMailable: #{mailable}\nDescription: #{description}"
  end  
  
  def revertTo(xmlGroup)
    group_hash = Hash.from_xml(xmlGroup)
    self.update_attributes group_hash["group"]
   # self.attributes = user_hash["user"] #FIXME Doesn't work... :S
  end
  
  
  # Create group hierarchy (includes itself)
  # Each array is a group
  # First element is tha name of the group, the rest are it's subgroups
  def subgroups_tree(groups_to_exclude=[])
    (self.groups - groups_to_exclude).map do |group| 
      group.subgroups_tree(self.groups | groups_to_exclude).unshift self
    end.unshift
  end
  
  #Create group names hierarchy as list
  def subgroups_names_tree(groups_to_exclude=[self])
    (self.groups - groups_to_exclude).map do |group| 
      group.subgroups_names_tree(self.groups | groups_to_exclude)
    end.unshift self.name
  end
   

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self

  end
  
end

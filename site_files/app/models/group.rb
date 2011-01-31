class Group < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================

  has_and_belongs_to_many :groups,       :association_foreign_key => "include_group_id"
  has_and_belongs_to_many :direct_users, :class_name => "User"
  #has_and_belongs_to_many :projects


  # ==========================================================================
  # Validations
  # ==========================================================================

  named_scope :not_deleted, :conditions => {:deleted => false}
  validates_uniqueness_of :name
  
  
  # ==========================================================================
  # Instance Methods
  # ==========================================================================
  
  # FIXME subgroups is deprecated!
  #Returns parent name
  def subgroups_names
    self.subgroups.map(&:name).join ", "
  end

  # FIXME subgroups is deprecated!
  #Give all users
  def all_users
    self.direct_users | subgroups.map(&:direct_users).flatten
  end

  # FIXME subgroups is deprecated!  
  #Retrieves and array containing all subgroups
  def subgroups
    subgroups_tree.flatten[1..-1]
  end

  #FIXME
  def pretty_print
    "Name: #{name}\nMailable: #{mailable}\nDescription: #{description}"
  end  
  
  # Reverts group attributes
  def revertTo(xmlGroup)
    group_hash = Hash.from_xml(xmlGroup)
    self.update_attributes group_hash["group"]
  end
  
  # FIXME subgroups is deprecated!  
  # Create group hierarchy (includes itself)
  # Each array is a group
  # First element is the name of the group, the rest are it's subgroups
  def subgroups_tree(groups_to_exclude=[])
    (self.groups - groups_to_exclude).map do |group| 
      group.subgroups_tree(self.groups | groups_to_exclude).unshift self
    end.unshift
  end

  # FIXME subgroups is deprecated!  
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

    def find_groups_to_show_in_user_actions
      Group.find_all_by_show_in_user_actions true
    end

  end
  
end

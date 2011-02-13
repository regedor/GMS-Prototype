class Group < ActiveRecord::Base

  # ==========================================================================
  # Relationships
  # ==========================================================================

  has_many                :groups_users
  has_many                :direct_users, :through => :groups_users, :source => :user
  has_and_belongs_to_many :groups,       :association_foreign_key => "include_group_id"


  # ==========================================================================
  # Validations
  # ==========================================================================

  validate                :validate_behavior
  validates_uniqueness_of :name
  
  def validate_behavior
    unless self.behavior_type.blank?
      errors.add_to_base 'Time must be > 0' if self.behavior_type == 'after_time' && self.behavior_after_time <= 0
    end
  end

  
  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  before_save   :set_behavior
  after_save    :update_user_count

  # Used to distinguish the types of behavior in forms and save operations
  attr_accessor :behavior_type

  # Returns all the users in the group and its subgroups
  def all_users
    self.direct_users | subgroups.map(&:direct_users).flatten
  end

  # Retrieves an array containing all subgroups
  def subgroups
    subgroups_tree.flatten || []
  end

  # Retrieves an array containing all subgroup names
  def subgroups_names
    subgroups_names_tree.flatten || []
  end

  # Create group hierarchy (includes itself)
  # Each array is a group
  # First element is the group itself, the rest are it's subgroups
  def subgroups_tree(groups_to_exclude=[self])
    (self.groups - groups_to_exclude).map do |group| 
      group.subgroups_tree(self.groups | groups_to_exclude)
    end.unshift self
  end

  # Create group names hierarchy as list
  def subgroups_names_tree(groups_to_exclude=[self])
    (self.groups - groups_to_exclude).map do |group| 
      group.subgroups_names_tree(self.groups | groups_to_exclude)
    end.unshift self.name
  end

  def set_behavior
    if self.behavior_type.blank?
      self.behavior_at_time = nil
      self.behavior_after_time = nil
      self.behavior_file_name = nil
    else
      self.behavior_after_time = nil if self.behavior_type == 'at_time'
      self.behavior_at_time = nil    if self.behavior_type == 'after_time'
    end
  end

  # Updates the number of users from the group and its subgroups
  # Used raw SQL to avoid cyclic after_save callback
  def update_user_count
    self.subgroups.each do |group|
      #group.update_attribute :user_count, group.all_users.size
      ActiveRecord::Base::connection().update("UPDATE groups SET user_count = #{group.all_users.size} WHERE id = #{group.id}") 
    end
  end


  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self

    #FIXME 
    # Maybe override the delete class method, not sure
    # Deletes users from their ids
    def delete_by_ids!(ids)
      ids.each do |id|
        return false unless Group.delete(id)
      end
      return true
    end

  end
  
end

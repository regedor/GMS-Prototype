class Group < ActiveRecord::Base

  # ==========================================================================
  # Relationships
  # ==========================================================================

  has_many                :groups_users
  has_many                :direct_users,           :through => :groups_users, :source => :user
  has_and_belongs_to_many :groups,                 :association_foreign_key => "include_group_id"
  belongs_to              :behavior_group_to_jump, :foreign_key => "behavior_group_to_jump_id", :class_name => 'Group'


  # ==========================================================================
  # Validations
  # ==========================================================================

  validate                :validate_behavior
  validates_uniqueness_of :name
  
  def validate_behavior
    unless self.behavior_type.blank?
      errors.add(:behavior_after_time, I18n::t('admin.groups.form.behavior.errors.negative_time')) if self.behavior_type == 'after_time' && self.behavior_after_time <= 0
      errors.add(:behavior_file_name, I18n::t('admin.groups.form.behavior.errors.file_trick')) if self.behavior_file_name.index(/[\/\\]/).nil? && (Dir["lib/group_behaviors/*.rb"].map { |file| file.gsub(/.+\/(.+)\.rb/) { $1 } }.member? self.behavior_file_name)
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

  # Executes the group behaviour
  # Creates a new dealyed_job if needed
  def execute_behaviour
   # if ::by_date
   #   send "Behaviour::#{::self.behaviour}::execute", self.direct_users, ::new_group_id => self.behaviour_group_to_id
   #   
   # else
   #   users = self.group_users :order => "created_at ASC", :limit => 2
   #   if not users.empty?
   #     send "Behaviour::#{::self.behaviour}::execute", [users.first], ::new_group_id => self.behaviour_group_to_id
   #   elsif users.size == 2
   #     delay.execute_behaviour
   #   end
   #   
   # end
  end


  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self

    #FIXME 
    def delete_by_ids!(ids)
      ids.each do |id|
        return false unless Group.delete(id)
      end
      return true
    end


    # Updates delayed_jobs table
    #
    def update_behaviour_delayed_jobs

    end


  end
  
end

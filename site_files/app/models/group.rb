class Group < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================

  belongs_to              :parent_group, :class_name => "Group", :foreign_key => "parent_group_id"
  has_many                :subgroups,    :class_name => "Group", :foreign_key => "parent_group_id"
  has_and_belongs_to_many :users


  # ==========================================================================
  # Validations
  # ==========================================================================

  validate :parent_is_not_own_descendent  
  named_scope :not_deleted, :conditions => {:deleted => false}


  # ==========================================================================
  # Instance Methods
  # ==========================================================================
  
  #Returns parent name
  def parent_name
    if self.parent_group.nil?
    
      return ""
    else
    
      return self.parent_group.name
    end    
  end

  def authorized_for?(*args)
    !deleted
  end

  def deleted?
    deleted
  end

  # Destroys a group
  def destroy
    self.subgroups.each do |subgroup|
      subgroup.destroy unless subgroup == self
    end
    self.deleted = true
    self.parent_group = nil
    save
  end
  
  #Give all users
  def all_users
    us = self.subgroups.map do |g| g.users end
    us.flatten! if us
    us.uniq! if us
    self.users + us
  end
  
  #Give all users names
  def all_users_names
    users_groups = {}
    users_hash   = {}
    self.subgroups.each do |subgroup|
      users = (subgroup.users - self.users).flatten.uniq
      users.map { |u| users_groups[u.id] ? users_groups[u.id] << subgroup : users_groups[u.id] = [subgroup] } unless users.empty?
      users.map { |u| users_hash[u.id] ||= u } unless users.empty? 
    end
    
    #FIXME: To move to Helper
    users = {}
    users_groups.each do |k,v|
      v.each do |group|
        if users[k]
          users[k] += ", #{group.name}"
        else
          users[k]  = users_hash[k].name + " (" + group.name  
        end
      end
    end
    
   subgroups_users  = users.values.join "), "
   subgroups_users += ")" unless subgroups_users.nil? || subgroups_users.blank?
   
   group_users = ((self.users.map &:name).join ", ")  
   group_users += ", " unless group_users.nil? || group_users.blank? || subgroups_users.nil? || subgroups_users.blank?
   
   return group_users + subgroups_users
  end
  
  #Check if is not subgroup of itself
  def parent_is_not_own_descendent
    group = self
    while group = group.parent_group
      if group.id == self.id 
        errors.add(I18n.t("admin.groups.modify.error.subgroup_of_self")+", ")
        
        return false
      end
    end
  end
  
  #Create group names hierarchy as sublists
  def subgroups_tree
    self.subgroups.map(&:subgroups_tree).unshift self
  end
  
  #Create group hierarchy as sublists
  def subgroups_names_tree
    self.subgroups.map(&:subgroups_names_tree).unshift self.name
  end
   
  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self

    #Create group hierarchy as sublists for All nodes
    def subgroups_names_tree
      self.find_all_by_parent_group_id(nil).map(&:subgroups_names_tree).unshift nil
    end

  end
  
end

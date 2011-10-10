class UserOptionalGroupPick < ActiveRecord::Base
  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  belongs_to  :role
  has_many    :groups


  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_uniqueness_of :name
  validates_uniqueness_of :role_id


  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  attr_accessor  :selected_group
  attr_accessor  :selected_group_id


  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self

    def for_role(role_id)
      conditions = "role_id <= #{role_id}"
      UserOptionalGroupPick.all(:conditions => conditions)
    end

    # Returns all optional group picks for a user
    def for_user(user)           
      conditions = "(id IN (#{user.groups.map(&:user_optional_group_pick).join(",")})) AND (role_id <= #{user.role_id} OR role_id IS NULL)"
      UserOptionalGroupPick.all(:conditions => conditions)
    end

    # Returns all optional group picks for a user with the selected option for each group pick
    def for_user_with_selected(user)
      conditions = "(id IN (#{user.groups.map(&:user_optional_group_pick).join(",")})) AND (role_id <= #{user.role_id} OR role_id IS NULL)"
      picks = UserOptionalGroupPick.all(:conditions => conditions)
      picks.each do |pick|
        unless (intersection = (user.groups & pick.groups)).empty?
          pick.selected_group    = intersection.first
          pick.selected_group_id = pick.selected_group.id
        end
      end
    end

  end

end

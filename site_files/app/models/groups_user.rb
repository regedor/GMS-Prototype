class GroupsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  after_create :update_group_user_count

  def update_group_user_count
    self.group.update_user_count
  end

end

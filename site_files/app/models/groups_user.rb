class GroupsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  after_create :update_group_user_count
  after_destroy do |record|
    pos = Position.find_by_user_id_and_group_id(record.user_id,record.group_id)
    pos.destroy if pos
  end

  def update_group_user_count
    self.group.update_user_count
  end

end

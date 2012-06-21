class Position < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  before_save :user_belongs_to_group?
  validates_presence_of :name
  validates_uniqueness_of :user_id, :scope => [:group_id]
  
  def to_json(options={})
    super(:only => :name)
  end
  
  private
  
  def user_belongs_to_group?
    user = User.find(self.user_id)
    user.group_ids.include? self.group_id
  end
end
class RefactorGroupPicks < ActiveRecord::Migration
  def self.up
    remove_column :user_optional_group_picks, :description
    remove_column :user_optional_group_picks, :group_id
    change_column :user_optional_group_picks, :role_id, :integer, :null => false
    add_column    :groups, :user_optional_group_pick_id, :integer
    drop_table :groups_user_optional_group_picks
  end

  def self.down
    add_column :user_optional_group_picks, :description, :text
    add_column :user_optional_group_picks, :group_id, :integer
    remove_column    :groups, :user_optional_group_pick_id
    change_column :user_optional_group_picks, :role_id, :integer, :null => true
    create_table "groups_user_optional_group_picks", :id => false, :force => true do |t|
      t.integer "group_id"
      t.integer "user_optional_group_pick_id"
    end
  end
end

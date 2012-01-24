class AddDeletedUsersIndex < ActiveRecord::Migration
  def self.up
    add_index :users, :deleted, :name => "users_name_index"
  end

  def self.down
    remove_index :users, :deleted
  end
end

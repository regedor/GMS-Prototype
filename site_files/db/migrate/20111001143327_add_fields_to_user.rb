class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :address, :text
    add_column :users, :id_number, :integer
  end

  def self.down
    remove_column :users, :address
    remove_column :users, :id_number
  end
end

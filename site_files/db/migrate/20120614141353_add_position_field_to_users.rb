class AddPositionFieldToUsers < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.string  :name, :default => "Membro"
      t.integer :user_id
      t.integer :group_id
    end
    add_index :positions, [:user_id,:group_id], :unique => true, :name => "one_position_per_group"
  end

  def self.down
    drop_table :positions
    remove_index :positions, :name => "one_position_per_group"
  end
end

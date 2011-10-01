class AddBooleansToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :requires_address, :boolean
    add_column :events, :requires_phone, :boolean
    add_column :events, :requires_id, :boolean
    add_column :events, :requires_name, :boolean
  end

  def self.down
    remove_column :events, :requires_address 
    remove_column :events, :requires_phone
    remove_column :events, :requires_id
    remove_column :events, :requires_name
  end                                         
end

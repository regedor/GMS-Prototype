class FixEvents < ActiveRecord::Migration
  def self.up
    rename_column :events, :title,   :name
    add_column    :events, :post_id, :integer 
  end

  def self.down
    rename_column :events, :name,    :title
    remove_column :events, :post_id, :integer 
  end
end

class AddTimestampsToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.timestamps
    end
  end

  def self.down
    remove_column :images, :updated_at
    remove_column :images, :created_at
  end
end

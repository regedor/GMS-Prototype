class AddTimestampsToAlbums < ActiveRecord::Migration
  def self.up
    change_table :albums do |t|
      t.timestamps
    end
  end

  def self.down
    remove_column :albums, :updated_at
    remove_column :albums, :created_at
  end
end

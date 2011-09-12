class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :name
    end
    add_index :albums, :name, :unique => true
    
    create_table :images do |t|
      t.string  :path
      t.integer :album_id
    end  
  end

  def self.down
    drop_table :albums
    drop_table :images
  end
end

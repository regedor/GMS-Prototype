class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :name
    end
    
    create_table :images do |t|
      t.string :path
    end  
  end

  def self.down
    drop_table :albums
    drop_table :images
  end
end

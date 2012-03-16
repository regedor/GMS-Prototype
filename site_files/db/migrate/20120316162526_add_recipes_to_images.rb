class AddRecipesToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :recipe_id, :integer
  end

  def self.down
    remove_column :images, :recipe_id
  end
end

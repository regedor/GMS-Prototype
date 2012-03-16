class AddPublicationDateToRecipes < ActiveRecord::Migration
  def self.up
    add_column :recipes, :publication_date, :date
    add_column :recipes, :image_id, :integer
    add_column :recipes, :recipe_dificulty_id, :integer
    remove_column :recipes, :dificulty_id
  end

  def self.down
    remove_column :recipes, :publication_date
    remove_column :recipes, :image_id
    remove_column :recipes, :recipe_dificulty_id
    add_column :recipes, :dificulty_id, :integer
  end
end

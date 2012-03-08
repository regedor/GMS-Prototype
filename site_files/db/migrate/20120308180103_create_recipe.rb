class CreateRecipe < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.string  :name
      t.integer :recipe_category_id
      t.integer :number_of_people
      t.integer :duration_in_minutes # based on this one can infer if it is fast or slow, etc...
      t.integer :dificulty_id
      t.text    :preparation_description
      t.integer :number_of_votes
    end
    
    create_table :recipe_categories do |t|
      t.string :name
    end
    
    create_table :recipe_dificulties do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :recipes
    drop_table :recipe_categories
    drop_table :recipe_dificulty
  end
end

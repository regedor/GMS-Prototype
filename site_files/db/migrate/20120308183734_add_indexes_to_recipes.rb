class AddIndexesToRecipes < ActiveRecord::Migration
  def self.up
    add_index :recipes, :number_of_votes
  end

  def self.down
    remove_index :recipes, :number_of_votes
  end
end

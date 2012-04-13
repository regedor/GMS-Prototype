class ChangeRecipesDuration < ActiveRecord::Migration
  def self.up
    change_column :recipes, :duration_in_minutes, :string
    add_column    :recipes, :ingredients, :text
  end

  def self.down
    change_column :recipes, :duration_in_minutes, :integer
    remove_column :recipes, :ingredients
  end
end

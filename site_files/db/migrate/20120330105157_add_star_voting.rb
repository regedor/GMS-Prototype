class AddStarVoting < ActiveRecord::Migration
  def self.up
    create_table :recipes_votes do |t|
      t.integer :recipe_id
      t.integer :user_id
      t.integer :vote
    end
    add_column :recipes, :voting_total, :integer
    add_column :recipes, :voting_average, :integer
  end

  def self.down
    drop_table :recipes_votes
    remove_column :recipes, :voting_total
    remove_column :recipes, :voting_average
  end
end

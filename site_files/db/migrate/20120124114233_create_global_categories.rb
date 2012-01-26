class CreateGlobalCategories < ActiveRecord::Migration
  def self.up
    create_table :global_categories do |t|
      t.string  :name        ,   :null => false
      t.integer :group_id
    end
  end

  def self.down
    drop_table :global_categories
  end
end

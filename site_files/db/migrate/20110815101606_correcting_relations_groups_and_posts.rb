class CorrectingRelationsGroupsAndPosts < ActiveRecord::Migration
  def self.up
    drop_table :groups_posts
    add_column :posts, :group_id, :integer, :default => 0      
  end

  def self.down
    create_table :groups_posts, :id => false do |t|
      t.integer :group_id
      t.integer :post_id
    end
    remove_column :posts, :group_id
  end
end

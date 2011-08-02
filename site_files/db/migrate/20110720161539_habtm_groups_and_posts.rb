class HabtmGroupsAndPosts < ActiveRecord::Migration
  def self.up
    create_table :groups_posts, :id => false do |t|
      t.integer :group_id
      t.integer :post_id
    end  
  end

  def self.down
    drop_table :groups_posts
  end
end

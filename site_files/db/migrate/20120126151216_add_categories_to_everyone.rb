class AddCategoriesToEveryone < ActiveRecord::Migration
  def self.up
    add_column :posts, :global_category_id, :integer, :default => 1
    add_column :announcements, :global_category_id, :integer, :default => 1
    add_column :pages, :global_category_id, :integer, :default => 1
    add_column :events, :global_category_id, :integer, :default => 1
    add_column :groups, :global_category_id, :integer, :default => 1
    remove_column :global_categories, :group_id
    
    add_column :global_categories, :slug, :string, :null => false, :default => "error"
    GlobalCategory.reset_column_information
 
    GlobalCategory.all.each do |cat|
      cat.slug = cat.name.downcase
      cat.save!
    end
 
    change_column_default :global_categories, :slug, nil
  end

  def self.down
    remove_column :posts, :global_category_id
    remove_column :announcements, :global_category_id
    remove_column :pages, :global_category_id
    remove_column :events, :global_category_id
    remove_column :groups, :global_category_id
    add_column :global_categories, :group_id, :integer
    remove_column :global_categories, :slug
  end
end

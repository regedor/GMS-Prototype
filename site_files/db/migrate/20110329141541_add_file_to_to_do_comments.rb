class AddFileToToDoComments < ActiveRecord::Migration
  def self.up
    add_column :to_do_comments, :generic_file_name     , :string
    add_column :to_do_comments, :generic_content_type  , :string
    add_column :to_do_comments, :generic_file_size     , :integer
    add_column :to_do_comments, :generic_updated_at    , :datetime
  end

  def self.down
    remove_column :to_do_comments, :generic_file_name    
    remove_column :to_do_comments, :generic_content_type 
    remove_column :to_do_comments, :generic_file_size    
    remove_column :to_do_comments, :generic_updated_at
  end
end

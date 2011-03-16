class AddPictureToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :image_file_name     , :string
    add_column :posts, :image_content_type  , :string
    add_column :posts, :image_file_size     , :integer
    add_column :posts, :image_updated_at    , :datetime
  end

  def self.down
  end
end

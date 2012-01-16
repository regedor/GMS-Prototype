class ChangeEventName < ActiveRecord::Migration
  def self.up
    Event.reset_column_information
    if Event.column_names.include?('title')
      Event.all.map(&:destroy)
      remove_column :events, :title
      remove_column :events, :description
      remove_column :events, :description_html
      add_column :events, :name, :string
      add_column :events, :has_announcement, :boolean, :default => false
      add_column :events, :post_id, :integer
      add_column :events, :announcement_id, :integer
    end
  end

  def self.down
    Event.reset_column_information
    if Event.column_names.include?('name')
      add_column :events, :title, :string
      add_column :events, :description
      add_column :events, :description_html
      remove_column :events, :name
      remove_column :events, :has_announcement
      remove_column :events, :post_id
      remove_column :events, :announcement_id
    end
  end
end

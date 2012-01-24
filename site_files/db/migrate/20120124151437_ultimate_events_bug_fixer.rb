class UltimateEventsBugFixer < ActiveRecord::Migration
  def self.up
    Event.reset_column_information
    add_column :events, :has_announcement, :boolean, :default => false if !Event.column_names.include?('has_announcement')
    add_column :events, :post_id, :integer if !Event.column_names.include?('post_id')
    add_column :events, :announcement_id, :integer if !Event.column_names.include?('announcement_id')
  end

  def self.down
    Event.reset_column_information
    add_column :events, :has_announcement, :boolean, :default => false if Event.column_names.include?('has_announcement')
    add_column :events, :post_id, :integer if Event.column_names.include?('post_id')
    add_column :events, :announcement_id, :integer if Event.column_names.include?('announcement_id')
  end
end

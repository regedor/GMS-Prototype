class ChangeAnnouncements < ActiveRecord::Migration
  def self.up
    change_column :announcements, :starts_at, :string, :null => false
    change_column :announcements, :message, :string, :null => true
  end

  def self.down
    change_column :announcements, :starts_at, :string, :null => true
    change_column :announcements, :message, :string, :null => false
  end
end

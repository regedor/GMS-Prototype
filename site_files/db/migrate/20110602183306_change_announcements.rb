class ChangeAnnouncements < ActiveRecord::Migration
  def self.up
    change_column :announcements, :starts_at, :datetime, :null => false
    change_column :announcements, :message, :string, :null => true
  end

  def self.down
    change_column :announcements, :starts_at, :datetime, :null => true
    change_column :announcements, :message, :string, :null => false
  end
end

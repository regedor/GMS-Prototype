class AddEventToAnnouncement < ActiveRecord::Migration
  def self.up
    add_column :announcements, :event_id, :integer
  end

  def self.down
    remove_column :announcements, :event_id, :integer 
  end
end

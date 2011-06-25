class RenamePagesShowAnnouncements < ActiveRecord::Migration
  def self.up
    rename_column :pages, :showAnnouncements, :show_announcements
  end

  def self.down
    rename_column :pages, :show_announcements, :showAnnouncements
  end
end

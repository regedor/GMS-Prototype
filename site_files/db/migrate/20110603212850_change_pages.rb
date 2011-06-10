class ChangePages < ActiveRecord::Migration
  def self.up
    add_column :pages, :showAnnouncements, :boolean
    change_column :pages, :showAnnouncements, :boolean, :default => true
    Page.update_all ["showAnnouncements = ?", true]
  end

  def self.down
    remove_column :pages, :showAnnouncements, :boolean
  end
end

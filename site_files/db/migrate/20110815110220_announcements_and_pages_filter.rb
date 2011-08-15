class AnnouncementsAndPagesFilter < ActiveRecord::Migration
  def self.up
    add_column :announcements, :group_id, :integer, :default => 0
    change_column :pages, :group_id, :integer, :default => 0
    Page.update_all ["group_id = ?",0]
  end

  def self.down
    remove_column :announcements, :group_id
    change_column :pages, :group_id, :integer
  end
end

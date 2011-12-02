class MakeEventsSubscribable < ActiveRecord::Migration
  def self.up
    add_column :events, :subscribable, :boolean, :default => true
  end

  def self.down
    remove_column :events, :subscribable
  end
end

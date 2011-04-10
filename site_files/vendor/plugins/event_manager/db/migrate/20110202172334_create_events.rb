class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string   :title
      t.string   :description
      t.datetime :starts_at
      t.datetime :ends_at
      t.float    :price,        :default => 0
      t.string   :participation_message

      t.timestamps
    end

    create_table :events_users do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :status_id,     :default => 1
      t.float   :total_price,   :default => 0
    end

    add_index :events_users, [:event_id, :user_id], :unique => true

    create_table :event_activities_users do |t|
      t.integer :event_activity_id
      t.integer :event_id
      t.integer :user_id
      t.integer :status_id,     :default => 1
    end

    add_index :event_activities_users, [:event_activity_id, :user_id], :unique => true

    create_table :event_activities do |t|
      t.integer  :event_id
      t.string   :title
      t.string   :description
      t.float    :price,        :default => 0
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end

    create_table :statuses do |t|
      t.string :name
    end

  end

  def self.down
    drop_table :events
    drop_table :event_activities
  end
end

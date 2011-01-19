class AddProjectsTables < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string  :name,           :null => false
      t.integer :user_id
      t.integer :blackboard_id
      t.text    :description
      t.timestamps
    end
    
    create_table :to_do_lists do |t|
      t.string  :name,          :null => false
      t.text    :description
      t.integer :project_id 
    end
    
    create_table :to_dos do |t|
      t.boolean    :done,         :default => false
      t.text       :description,                      :null => false
      t.integer    :to_do_list_id
      t.timestamps
    end
    
    create_table :blackboards do |t|
      t.text     :content
    end
    
    create_table :groups_projects, :id => false do |t|
      t.integer :group_id
      t.integer :project_id
    end
    
  end

  def self.down
    drop_table "projects"
    drop_table "to_do_lists"
    drop_table "to_do"
    drop_table "blackboards"
    drop_table "groups_projects"
  end
end

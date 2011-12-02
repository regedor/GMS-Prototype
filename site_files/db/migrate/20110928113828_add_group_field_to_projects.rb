class AddGroupFieldToProjects < ActiveRecord::Migration
  def self.up
    drop_table :projects_users
    drop_table :groups_projects
    add_column :projects, :group_id, :integer
  end

  def self.down
    create_table "projects_users", :id => false, :force => true do |t|
      t.integer "user_id"
      t.integer "project_id"
    end
    
    create_table "groups_projects", :id => false, :force => true do |t|
      t.integer "group_id"
      t.integer "project_id"
    end
    
    remove_column :projects, :group_id
  end
end

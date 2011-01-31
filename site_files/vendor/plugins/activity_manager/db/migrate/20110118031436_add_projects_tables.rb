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
      t.integer    :user_id   #assigned_to
      t.datetime   :due_date
      t.datetime   :finished_date
      t.timestamps
    end
    
    create_table :blackboards do |t|
      t.text     :content
    end
    
    create_table :groups_projects, :id => false do |t|
      t.integer :group_id
      t.integer :project_id
    end
    
    create_table :projects_users, :id => false do |t|
      t.integer :user_id
      t.integer :project_id
    end
    
    create_table :messages do |t|
      t.string   :title,                :null => false
      t.text     :body,                 :null => false
      t.text     :body_html,            :null => false
      t.integer  :category_id,		:null => false
      t.integer  :user_id,              :null => false
      t.integer  :project_id,           :null => false
      t.timestamps
    end 
        
    

    create_table :categories do |t|
      t.string   :name,       		:null => false
      t.timestamps
    end
    
    create_table :messages_comments do |t|  
      t.text      :body,                 :null => false
      t.text      :body_html,            :null => false
      t.integer   :user_id,              :null => false
      t.integer   :message_id,           :null => false
      t.timestamps
    end

  end

  def self.down
    drop_table "projects"
    drop_table "to_do_lists"
    drop_table "to_do"
    drop_table "blackboards"
    drop_table "groups_projects"
    drop_table "messages"
    drop_table "categories"
  end
end

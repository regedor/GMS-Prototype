class ScaffoldApp < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      # User info
      t.string    :email,               :null => false,                   :limit => 100  
      t.string    :nickname
      t.string    :name
      t.text      :profile
      t.string    :website
      t.string    :language,            :null => false, :default => "en" 
      t.string    :country 
      
      t.boolean   :active,              :null => false, :default => false  #TEMP!!!
      t.integer   :role         #TEMP!!!
      
      t.integer   :user_state_id       #:null => false
      t.boolean   :gender,              :null => false, :default => true # True = Male and False = Female
      t.string    :phone 
      
      # Utils
      t.string    :openid_identifier
      t.string    :crypted_password
      t.string    :password_salt
      t.string    :persistence_token,   :null => false  # required
      t.string    :single_access_token, :null => false  # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false  # optional, see Authlogic::Session::Perishability      
      t.timestamps
      # optional, see Authlogic::Session::MagicColumns
      t.integer   :login_count,         :null => false, :default => 0 
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at                                    
      t.datetime  :current_login_at                                   
      t.datetime  :last_login_at                                      
      t.string    :current_login_ip                                   
      t.string    :last_login_ip
      t.boolean   :deleted,             :null => false, :default => false 
    end
    add_index :users, :email, :unique => true

    create_table :open_id_authentication_associations, :force => true do |t|
      t.integer :issued, :lifetime
      t.string :handle, :assoc_type
      t.binary :server_url, :secret
    end

    create_table :open_id_authentication_nonces, :force => true do |t|
      t.integer :timestamp, :null => false
      t.string :server_url, :null => true
      t.string :salt, :null => false
    end

    # Create Settings Table
    create_table :settings, :force => true do |t|
      t.string :label
      t.string :identifier
      t.text   :description
      t.string :field_type, :default => 'string'
      t.text   :value
      t.boolean   :editable, :null => false, :default => true
      t.timestamps
    end
 
    create_table :announcements do |t|
      t.text :headline,        :null => false
      t.text :message,         :null => false
      t.datetime :starts_at
      t.datetime :ends_at
    end

    create_table :pages do |t|
      t.string   :title,      :null => false
      t.string   :slug,       :null => false
      t.text     :body,       :null => false
      t.text     :body_html,  :null => false
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :pages, ["title"], :name => 'index_pages_on_title'
    add_index :pages, ["created_at"], :name => 'index_pages_on_created_at'

    create_table :posts do |t|
      t.string   :title,                                                      :null => false
      t.string   :slug,                                                       :null => false
      t.text     :body,                                                       :null => false
      t.text     :body_html,                                                  :null => false
      t.boolean  :active,                  :default => true,                  :null => false
      t.integer  :approved_comments_count, :default => 0,                     :null => false
      t.string   :cached_tag_list
      t.timestamps
      t.datetime :published_at
      t.datetime :edited_at,                                                  :null => false
      t.boolean   :deleted,                :default => false,                 :null => false
    end

    create_table :comments do |t|
      t.integer  :post_id,                 :null => false
      t.string   :author,                  :null => false
      t.string   :author_url,              :null => false
      t.string   :author_email,            :null => false
      t.text     :body,                    :null => false
      t.text     :body_html,               :null => false
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean   :deleted,                :null => false,                    :default => false
    end
    add_index :comments, ["post_id"], :name => 'index_comments_on_post_id'
    add_index :comments, ["created_at"], :name => 'index_comments_on_created_at'

    create_table :taggings do |t|
      t.integer  :tag_id
      t.integer  :taggable_id
      t.datetime :created_at
    end
    add_index :taggings, ["taggable_id"], :name => 'index_taggings_on_taggable_id_and_taggable_type'
    add_index :taggings, ["tag_id"], :name => 'index_taggings_on_tag_id'

    create_table :tags do |t|
      t.string  :name
      t.integer :taggings_count, :default => 0, :null => false
    end
    add_index :tags, ["name"], :name => 'index_tags_on_name'

    create_table :undo_items, :force => true do |t|
      t.string   :type,       :null => false
      t.datetime :created_at, :null => false
      t.text     :data
    end
    add_index :undo_items, ["created_at"], :name => 'index_undo_items_on_created_at'

    create_table :groups do |t|
      t.integer :parent_group_id
      t.string  :name,            :null => false
      t.text    :description
      t.boolean :mailable,        :null => false
      t.boolean  "deleted",       :default => false, :null => false
      t.timestamps
    end  

    create_table :groups_users, :id => false do |t|
      t.integer :group_id
      t.integer :user_id
    end

    create_table :user_states do |t|
      t.string :label, :null => false
    end  

  end

  def self.down
    raise IrreversibleMigration
  end
end

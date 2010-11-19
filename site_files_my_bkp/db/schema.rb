# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100725205234) do

  create_table "announcements", :force => true do |t|
    t.text     "headline",  :null => false
    t.text     "message",   :null => false
    t.datetime "starts_at"
    t.datetime "ends_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id",      :null => false
    t.string   "author",       :null => false
    t.string   "author_url",   :null => false
    t.string   "author_email", :null => false
    t.text     "body",         :null => false
    t.text     "body_html",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"

  create_table "groups", :force => true do |t|
    t.integer  "parent_group_id"
    t.string   "name",            :null => false
    t.text     "description"
    t.boolean  "mailable",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "slug",       :null => false
    t.text     "body",       :null => false
    t.text     "body_html",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["created_at"], :name => "index_pages_on_created_at"
  add_index "pages", ["title"], :name => "index_pages_on_title"

  create_table "posts", :force => true do |t|
    t.string   "title",                                     :null => false
    t.string   "slug",                                      :null => false
    t.text     "body",                                      :null => false
    t.text     "body_html",                                 :null => false
    t.boolean  "active",                  :default => true, :null => false
    t.integer  "approved_comments_count", :default => 0,    :null => false
    t.string   "cached_tag_list"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.datetime "edited_at",                                 :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "label"
    t.string   "identifier"
    t.text     "description"
    t.string   "field_type",  :default => "string"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0, :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "undo_items", :force => true do |t|
    t.string   "type",       :null => false
    t.datetime "created_at", :null => false
    t.text     "data"
  end

  add_index "undo_items", ["created_at"], :name => "index_undo_items_on_created_at"

  create_table "user_states", :force => true do |t|
    t.string "label", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",               :limit => 100,                    :null => false
    t.string   "nickname"
    t.string   "name"
    t.text     "profile"
    t.string   "website"
    t.string   "language",                           :default => "en",  :null => false
    t.string   "country"
    t.boolean  "active",                             :default => false, :null => false
    t.integer  "role"
    t.integer  "user_state_id"
    t.boolean  "gender",                             :default => true,  :null => false
    t.string   "phone"
    t.string   "openid_identifier"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                                     :null => false
    t.string   "single_access_token",                                   :null => false
    t.string   "perishable_token",                                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "login_count",                        :default => 0,     :null => false
    t.integer  "failed_login_count",                 :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "deleted",                            :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end


Factory.sequence :name do |n| 
  "#{Faker::Name.name} #{n}"
end

Factory.sequence :post_title do |n| 
  "#{Faker::Lorem.sentence} #{n}"
end

# ==========================================================================
# Defines Users
# ==========================================================================

Factory.define :valid_user, :class => User, :default_strategy => :create do |f|
  f.name                  Factory.next(:name)
  f.password              "foobar"
  f.password_confirmation { |u| u.password                }
  f.sequence(:email)      { |n| "johndoe#{n}@example.com" }
  f.role                  Role.find_by_symbol(:member)
  f.country               "PT"
  f.phone                 "123456789"
  f.gender                true
end

Factory.define :nameless_user, :class => User, :default_strategy => :create do |f|
  f.password              "foobar"
  f.password_confirmation { |u| u.password                }
  f.sequence(:email)      { |n| "johndoe#{n}@example.com" }
  f.role                  Role.find_by_symbol(:member)
  f.country               "PT"
  f.phone                 "123456789"
  f.gender                true
end


Factory.define :active_user, :parent => 'valid_user' do |f|
  f.active                true
end

Factory.define :root_user, :parent => 'active_user' do |f|
  f.role                  Role.find_by_symbol(:root)
end


# ==========================================================================
# Defines Deleted Users
# ==========================================================================

Factory.define :deleted_user, :class => DeletedUser, :default_strategy => :create do |f|
  f.name                  Factory.next(:name)
  f.password              "foobar"
  f.password_confirmation { |u| u.password                }
  f.sequence(:email)      { |n| "johndoe#{n}@example.com" }
  f.deleted               true
end


# ==========================================================================
# Defines Groups
# ==========================================================================

Factory.define :valid_group, :class => Group do |group|
  group.sequence(:name) { |n| "group #{n}"     }
end


# ==========================================================================
# Defines Posts
# ==========================================================================

Factory.define :valid_post, :class => Post do |post|
  post.sequence(:title) { |n| "post #{n}" }
  post.body         'Lorem'
  post.published_at Time.now - 1.day
end

# ==========================================================================
# Defines Projects
# ==========================================================================

Factory.define :project, :class => Project do |project|
  project.sequence(:name)       {|n| "#{Faker::Lorem.words} #{n}"}
  project.description           Faker::Lorem.sentence
  project.association           :group, :factory => :valid_group
end

# ==========================================================================
# Defines ToDoLists
# ==========================================================================

Factory.define :to_do_list do |list|
  list.name                  Faker::Lorem.words
  list.association           :project
end

# ==========================================================================
# Defines ToDos
# ==========================================================================

Factory.define :to_do do |todo|
  todo.description       Faker::Lorem.sentence
  todo.association       :to_do_list
end

# ==========================================================================
# Defines Events
# ==========================================================================

Factory.define :event do |event|
  event.name            Faker::Lorem.words
  event.start_at        Time.now - 1.day
  event.ends_at         Time.now + 1.day
  event.price           10
end


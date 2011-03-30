# ==========================================================================
# Defines Users
# ==========================================================================

Factory.define :valid_user, :class => User, :default_strategy => :create do |f|
  f.sequence(:name)       { |n| "John Doe #{n}"           }
  f.password              "foobar"
  f.password_confirmation { |u| u.password                }
  f.sequence(:email)      { |n| "johndoe#{n}@example.com" }
  f.role                  Role.find_by_symbol(:user)
end


Factory.define :active_user, :parent => 'valid_user' do |f|
  f.active                true
end

Factory.define :admin_user, :parent => 'active_user' do |f|
  f.role                  Role.find_by_symbol(:admin)
end


# ==========================================================================
# Defines Deleted Users
# ==========================================================================

Factory.define :deleted_user, :class => DeletedUser, :default_strategy => :create do |f|
  f.sequence(:name)       { |n| "John Doe #{n}"           }
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

Factory.define :valid_post do |post|
  post.title        'Great Post'
  post.body         'Lorem'
  post.published_at 'now'  
end



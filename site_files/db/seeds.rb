# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
#
puts "Creating standard roles..."
  Role.create :name => "root"
  Role.create :name => "admin"
  Role.create :name => "user"

puts "Creating standard groups..."
  default_group = Group.create :name => "Default",           :mailable => false
  root_group    = Group.create :name => "Root",              :mailable => false
  admin_group   = Group.create :name => "Administrators",    :mailable => false

puts "Creating admins..."
  user_regedor = User.new
  user_regedor.email             = 'miguelregedor@gmail.com'
  user_regedor.openid_identifier = 'https://www.google.com/accounts/o8/id?id=AItOawnbGyx78N1LosCVj5coDtzlvTjtRpcLu5c'
  user_regedor.name              = 'Miguel Regedor'
  user_regedor.language          = 'en'
  user_regedor.country           = 'PT'
  user_regedor.phone             = "00351964472540"
  user_regedor.gender            =  false
  user_regedor.role_id           =  1
  user_regedor.save
  user_regedor.activate!
  default_group.direct_users << user_regedor
  root_group.direct_users    << user_regedor
  admin_group.direct_users   << user_regedor
 
  root = User.new
  root.email                 = 'root@simon.com'
  root.password              = 'simonroot'
  root.password_confirmation = 'simonroot'
  root.name                  = 'Root'
  root.language              = 'en'
  root.country               = 'PT'
  root.phone                 = "123456789"
  root.gender                =  true
  root.role_id               =  1
  root.save
  root.activate!
  default_group.direct_users << root
  root_group.direct_users    << root
  admin_group.direct_users   << root

  admin = User.new
  admin.email                 = 'admin@simon.com'
  admin.password              = 'simonadmin'
  admin.password_confirmation = 'simonadmin'
  admin.name                  = 'Admin'
  admin.language              = 'en'
  admin.country               = 'PT'
  admin.phone                 = "123456789"
  admin.gender                =  true
  admin.role_id               =  2
  admin.save
  admin.activate!
  default_group.direct_users << admin
  admin_group.direct_users   << admin
  
puts "Saving Groups..."
  default_group.save
  root_group.save
  admin_group.save


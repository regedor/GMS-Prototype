# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
#

puts "Creating settings..."
  Setting.create :identifier => "frontend_navigation", :field_type => "string", :value => "<li><a href=\"/\">Notícias</a></li>__SelectedPages__"

puts "Creating standard roles..."
  File.open( "config/authorization_rules.rb" ) do |f| 
    f.grep( /role :([a-z_0-9]*) do/ ) do |line| 
      Role.create :label => $1
    end 
  end

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

puts "Creating projects... (DEBUG)"
  p1 = Project.new :name => "Project 1", :description => "O primeiro projecto do mundo!", :user_id => 1

  t1 = ToDo.new :description => "Fazer coisas" , :user => User.find(2), :due_date => Time.now 
  t2 = ToDo.new :description => "Comer bananas", :user => User.find(3), :due_date => Time.now + 1.day 
  t3 = ToDo.new :description => "Coçar tomates", :user => User.find(1), :due_date => Time.now + 2.days
  t4 = ToDo.new :description => "Aprender js"  , :user => User.find(3), :due_date => Time.now + 1.day 
  t5 = ToDo.new :description => "Aprender ruby", :user => User.find(1), :due_date => Time.now + 2.days  

  tdl1 = ToDoList.new :name => "Bota Remédio", :description => "Botar bué de remédio"
  tdl1.to_dos << t1
  tdl1.to_dos << t2
  tdl1.to_dos << t3
  t1.save
  t2.save
  t3.save
  tdl1.save

  tdl2 = ToDoList.new :name => "No idea", :description => "Quando souberes avisa"
  tdl2.to_dos << t4
  tdl2.to_dos << t5
  t4.save
  t5.save
  tdl2.save

  p1.to_do_lists << tdl1
  p1.to_do_lists << tdl2
  p1.save

  
  c1 = Category.new :name => "Categoria"
  c1.save
  m1 = Message.new :body => "Mensagem de bota remedio", :title => "Titulo de bota remedio", :category_id => 1, :user_id => 1, :project_id => 1
  m2 = Message.new :body => "Mensa", :title => "Mensa", :category_id => 1, :user_id => 1, :project_id => 1
  m1.save
  m2.save

  mc1 = MessagesComments.new :body => "ahuetz", :message_id => 1, :user_id => 1
  mc1.save


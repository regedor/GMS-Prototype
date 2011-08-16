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
  symbols = []
  File.open( "config/authorization_rules.rb" ) do |f| 
    f.grep( /role :([a-z_0-9]*) do/ ) { |line| symbols << $1 }
  end 
  symbols.reverse[1..-1].each { |role| Role.create :label => role }

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
  user_regedor.role_id           =  Role.id_for :root
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
  root.role_id               =  Role.id_for :root
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
  admin.role_id               =  Role.id_for :admin 
  admin.save
  admin.activate!
  default_group.direct_users << admin
  admin_group.direct_users   << admin
  
puts "Saving Groups..."
  default_group.save
  root_group.save
  admin_group.save

puts "Creating projects..."
  p1 = Project.new :name => "Project 1", :description => "O primeiro projecto do mundo!", :user_id => 1, :users => [User.first,User.find(2)]

  t1 = ToDo.new :description => "Fazer coisas" , :user => User.find(2), :due_date => Time.now.strftime("%d/%m/%Y")
  t2 = ToDo.new :description => "Entregar documento X", :user => User.find(3), :due_date => (Time.now+1.day).strftime("%d/%m/%Y")
  t3 = ToDo.new :description => "Falar com fulano de tal acerca daquela coisa", :user => User.find(1), :due_date =>  (Time.now+2.days).strftime("%d/%m/%Y")
  t4 = ToDo.new :description => "Aprender js"  , :user => User.find(3), :due_date => (Time.now+1.day).strftime("%d/%m/%Y")
  t5 = ToDo.new :description => "Aprender ruby", :user => User.find(1), :due_date => (Time.now+2.days).strftime("%d/%m/%Y")

  tdl1 = ToDoList.new :name => "Plano de Imagem", :description => "Preparar plano de imagem do projecto"
  tdl1.to_dos << t1
  tdl1.to_dos << t2
  tdl1.to_dos << t3
  t1.save
  t2.save
  t3.save
  tdl1.save

  tdl2 = ToDoList.new :name => "Gestão de sócios", :description => "Relativo a toda a gestão de associados"
  tdl2.to_dos << t4
  tdl2.to_dos << t5
  t4.save
  t5.save
  tdl2.save

  p1.to_do_lists << tdl1
  p1.to_do_lists << tdl2
  p1.save
  
  c1 = Category.new :name => "Categoria", :project_id => 1
  c1.save
  m1 = Message.new :body => "Mensagem de bota remedio", :title => "Titulo de bota remedio", :category_id => 1, :user_id => 1, :project_id => 1
  m2 = Message.new :body => "Mensa", :title => "Mensa", :category_id => 1, :user_id => 1, :project_id => 1
  m1.save
  m2.save

  mc1 = MessagesComment.new :body => "ahuetz", :message_id => 1, :user_id => 1
  mc1.save

puts "Creating events... (DEBUG)"
  e1 = Event.new :name => "Novo Evento XPTO", :starts_at => Time.now, :ends_at => Time.now + 2.days, :price => 200.10, :participation_message => "Obrigado por participar neste evento maravilhoso, para mais informações de como proceder ao pagamento, contacte o Zeca Ervilha, no cima do telhado do Departamento de Informática!"
  
  e2 = Event.new :name => "Outro Evento XPTO+", :starts_at => Time.now + 2.days, :ends_at => Time.now + 3.days, :price => 20, :participation_message => "Este evento vai ser bués de altamente! Ficamos gratos por mostrar interesse em participar! Para efectuar o pagamento, fale com o Carlos Cagalhota! (+351 252 40 22 02)"

  e3 = Event.new :name => "Jantar Multissensorial no Restaurante Panorâmico da Universidade do Minho", :starts_at => Time.now + 1.day, :ends_at => Time.now + 2.days, :participation_message => "Ainda bem que se inscreveu para este jantar, vai ser petáculo!"

  a3 = EventActivity.new :title => "Participação multissensorial em Ilhas alimentares (com venda nos olhos)", :description => "Indiscretível", :starts_at => Time.now, :ends_at => Time.now

  a4 = EventActivity.new :title => "Beber, cair e levantar!", :price => 15.0, :description => "petaculare!", :starts_at => Time.now, :ends_at => Time.now

  e3.save
  
  a3.event = e3
  a4.event = e3

  a3.users << User.all
  a4.users << User.find(1)

  a3.save
  a4.save

  a1 = EventActivity.new :title => "primeira actividade!", :description => "super", :starts_at => Time.now + 1.hour, :ends_at => Time.now + 1.day, :price => 100.10

  a2 = EventActivity.new :title => "segunda actividade!", :description => "ainda mais super", :starts_at => Time.now + 1.day, :ends_at => Time.now + 2.days, :price => 100

  Status.create(:name => "not confirmed")
  Status.create(:name => "confirmed")
  Status.create(:name => "rejected")

  e2.users << User.find(2)
  a1.users << User.find(1)
  a2.users << User.find(2)

  e1.save
  e2.save

  a1.event = e1
  a2.event = e1

  a1.save
  a2.save


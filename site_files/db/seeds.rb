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

puts "Creating admins..."
  root = User.new
  root.email                 = 'contact@groupbuddies.com'
  root.password              = 'password'
  root.password_confirmation = 'password'
  root.name                  = 'Root'
  root.language              = 'en'
  root.country               = 'PT'
  root.phone                 = "123456789"
  root.gender                =  true
  root.role_id               =  Role.id_for :root
  root.save
  root.activate!
  default_group.direct_users << root

puts "Saving Groups..."
  default_group.save

unless Setting.find_by_identifier "frontend_navigation"
  puts "Creating settings..."
  Setting.create :identifier => "frontend_navigation", :field_type => "string", :value => "<li><a href=\"/\">Notícias</a></li>__SelectedPages__"
end

if Role.count == 0
  puts "Creating standard roles..."
  symbols = []
  File.open( "config/authorization_rules.rb" ) do |f| 
    f.grep( /role :([a-z_0-9]*) do/ ) { |line| symbols << $1 }
  end 
  symbols.reverse[1..-1].each { |role| Role.create :label => role }
end

if Group.count == 0
  puts "Creating standard groups..."
  Group.create :name => "Group Buddies", :mailable => false
end

if GlobalCategory.all.empty?
  puts "Creating Category"
  GlobalCategory.create :name => "Default", :slug => "default" 
end

recipe_categories = [ 
  {:name => "Entrada"},
  {:name => "Prato Principal"},
  {:name => "Sobremesa"}
]

recipe_categories.each do |attributes| 
  RecipeCategory.find_or_initialize_by_name(attributes[:name]).save!
end

recipe_categories = [ 
  {:name => "Entrada"},
  {:name => "Prato Principal"},
  {:name => "Sobremesa"}
]

recipe_categories.each do |attributes| 
  RecipeCategory.find_or_initialize_by_name(attributes[:name]).save!
end

recipe_dificulties = [ 
  {:name => "Fácil"},
  {:name => "Médio"},
  {:name => "Difícil"}
]

recipe_dificulties.each do |attributes| 
  RecipeDificulty.find_or_initialize_by_name(attributes[:name]).save!
end



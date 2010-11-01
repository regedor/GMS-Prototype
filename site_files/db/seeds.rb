# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
#
puts "Creating admins!"
  user_regedor = User.new
  user_regedor.email             = 'miguelregedor@gmail.com'
  user_regedor.openid_identifier = 'https://www.google.com/accounts/o8/id?id=AItOawnbGyx78N1LosCVj5coDtzlvTjtRpcLu5c'
  user_regedor.name              = 'Miguel Regedor'
  user_regedor.language          = 'en'
  user_regedor.country           = 'PT'
  user_regedor.phone             = "00351964472540"
  user_regedor.gender            =  false
  user_regedor.role              =  User::ROLES[:admin]
  user_regedor.save
  
  user_zamith = User.new
  user_zamith.email                 = 'zamith.28@gmail.com'
  #user_zamith.openid_identifier = 'https://www.google.com/accounts/o8/id?id=AItOawnbGyx78N1LosCVj5coDtzlvTjtRpcLu5c'
  user_zamith.password              = 'oregedorebuedezeca'
  user_zamith.password_confirmation = 'oregedorebuedezeca'
  user_zamith.name                  = 'Luis Zamith'
  user_zamith.language              = 'en'
  user_zamith.country               = 'PT'
  user_zamith.phone                 = "00351964472540"
  user_zamith.gender                =  true
  user_zamith.role                  =  User::ROLES[:admin]
  user_zamith.save
  user_zamith.activate!
  
  Group.create(:name=>"Grupinho da moda",:mailable=>false)
  

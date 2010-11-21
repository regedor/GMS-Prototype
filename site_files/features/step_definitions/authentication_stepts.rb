require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am not logged in$/ do
end

When /^I click the link in the email$/ do
  click_first_link_in_email
end

Given /^I am logged in as admin$/ do 
  user = Factory.give_me_an_admin_user(:email => "root@example.com")
  visit("/user_session")
  fill_in("email", :with => user.email)
  fill_in("password", :with => user.password)
  click_button("Sign in")
end

Given /^I am logged in as "(.*)"$/ do |email|
  user = User.find_by_email email
  user.password = user.password_confirmation = "password"
  user.save
  visit("/login")
  fill_in("email", :with => user.email)
  fill_in("password", :with => user.password)
  click_button("Sign")
end

# Needs tweaking
#Given /^I am logged in as "(.*)"$/ do |name|
#  user = User.find_by_email(user)
#  post '/session', :openid_url => user.identity_url
#  # Some assertions just to make sure our hack in env.rb is still working
#  response.should redirect_to('/')
#  flash[:notice].should eql('Logged in successfully')
#end

Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |hash|
    Factory(factory, hash)
  end
end

Given /^the following activated users exists?$/ do |table|
  table.hashes.each do |hash|
    Factory.give_me_an_active_user(hash)
  end
end

And /^OpenID Server confirms?$/ do 
end

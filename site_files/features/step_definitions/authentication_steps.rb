require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am not logged in$/ do
end

When /^I click the link in the email$/ do
  click_first_link_in_email
end

Given /^I am logged in as an administrator$/ do
  user = Factory.give_me_an_admin(:email => "admin@example.com")
  visit("/user/session/new")
  fill_in("Email", :with => user.email)
  fill_in("Password", :with => user.password)
  click_button("Sign in")
end

Given /^I am logged in as a user$/ do
  user = Factory.give_me_a_user(:email => "user@example.com")
  visit("/user/session/new")
  fill_in("Email", :with => user.email)
  fill_in("Password", :with => user.password)
  click_button("Sign in")
end

Given /^I am logged in as "(.*)"$/ do |email|
  user = User.find_by_email email
  visit("/user/session/new")
  fill_in("Email", :with => user.email)
  fill_in("Password", :with => user.password)
  click_button("Sign in")
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

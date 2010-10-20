require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am not logged in$/ do
end

When /^I click the link in the email$/ do
  click_first_link_in_email
end

Given /^I am logged in as admin$/ do 
  user = Factory.give_me_an_admin_user(:email => "root@example.com")
  visit("/login")
  fill_in("email", :with => user.email)
  fill_in("password", :with => user.password)
  click_button("Login")
end

Given /^I am logged in as "(.*)"$/ do |email|
  user = User.find_by_email email
  user.password = user.password_confirmation = "password"
  user.save
  visit("/login")
  fill_in("email", :with => user.email)
  fill_in("password", :with => user.password)
  click_button("Login")
end

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

Given /^I18n is set to english$/ do 
  I18n.locale = :en
end

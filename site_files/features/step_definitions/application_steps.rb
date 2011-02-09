Then /^I should see a table$/ do    
  if defined?(Spec::Rails::Matchers)
    response.should have_tag("table")
  else
    assert_match("table", response_body)
  end
end 

Then /^I should not see a table$/ do
  if defined?(Spec::Rails::Matchers)
    response.should_not have_tag("table")
  else
    assert_match("table", response_body)
  end
end 

Given /^I18n is set to english$/ do 
  I18n.locale = :en
end

Given /^I18n is set to test$/ do 
  I18n.locale = :test
end

Given /^the DB has been initialized$/ do
  load "db/seeds.rb"
end

Given /^the following activated users? exists?$/ do |table|
  table.hashes.each do |hash|
    Factory(:active_user,hash)
  end
end

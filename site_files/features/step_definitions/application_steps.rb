Then /^I should see a table$/ do
    response.should have_tag("table")
end 

Then /^I should not see a table$/ do
    response.should_not have_tag("table")
end 

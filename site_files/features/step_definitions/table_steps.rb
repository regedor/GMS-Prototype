When /^as admin I (press|follow|check|uncheck|choose) "([^\"]*)" for (.*) whose (.*) is "([^\"]*)"$/ do |action, whatyouclick, class_name, var_name, value|
  unless var_name == "id" then
    id = eval("\"#{class_name}\".classify.constantize.find_by_#{var_name}(\"#{value}\").id.to_s")
  else
    id = value
  end
  within("tr[id=as_admin__#{class_name}-list-#{id}-row]") do
    case action
      when "press"
        click_button(whatyouclick)
      when "follow"
        click_link(whatyouclick)
      when "check"
        check(whatyouclick)
      when "uncheck"
        uncheck(whatyouclick)
      when "choose"
        uncheck(whatyouclick)
    end
  end
end

And /^I delete "(.*)"$/ do |person|
  # Use webrat or capybara to find row based on 'person' text... then find 'delete' link in row and click it
  # example (untested, pseudo code)
  within("table/tr[contains(#{person})") do
    find('.deleteLink').click
  end
end

Then /^I should see the following table:$/ do |expected_cukes_table|
  actual_table = [
    ['Latin', 'English'],
    ['Cucumis sativus', 'Concombre'],
    ['Cucumis anguria', 'Burr Gherkin']
  ] # In practice you'd pull this out of a web page, database or some other data store.

  expected_cukes_table.diff!(actual_table)
end
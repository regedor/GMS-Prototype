Given /^the following announcements:$/ do |table|
	table.hashes.each do |attributes|
		Announcement.create!(attributes)
	end
end

When /^I delete the "([^\"]*)"$/ do |arg1|
	click_link_within "table/tr[contains(#{arg1})]", "Delete"
end


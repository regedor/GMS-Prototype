Feature:
	In order to manage announcements
	As an admin
	I want to see an announcements list and manage announcements
	
	Background:
		Given the following announcements:
			| headline | message | starts_at | ends_at |
			| Announcement_1 | Test on Announcement 1 | Mon, 22 Nov 2010 16:21:00 +0000 | Fri, 26 Nov 2010 16:21:00 +0000 |
			| Announcement 2 | Test on the Announcement 2 | Fri, 26 Nov 2010 16:21:00 +0000 | Tue, 30 Nov 2010 16:22:00 +0000 |
	
	Scenario: Test the content of the announcements table
		Given I am logged in as admin 
		When I follow "Administration"
		And I follow "Website"
		And I follow "Announcements"
		And I should see "Announcement_1"
		And I should see "Announcement 2"
		
		
	Scenario: Test the content of the announcements table after inserting a new announcement
		Given I am logged in as admin
		When I follow "Administration"
		And I follow "Website"
		And I follow "Announcements"
		And I follow "New Announcement"
		And I fill in the following:
			|Headine | Announcement 3 |
			|Message | Test on annoncement 2 |
			| Start Date | Fri, 26 Nov 2010 16:21:00 +0000 |
			| End Date | Tue, 30 Nov 2010 16:22:00 +0000 |
		When I press "Create"
		Then I should see "Announcement 3"
	
	@selenium
	Scenario: Test the content of the announcements table after deleting an announcement
		Given I am logged in as admin
		When I follow "Administration"
		And I follow "Website"
		And I follow "Announcements"
		And I delete the "Announcement_2"
		Then I should see a JS "Are You Sure"
		And I should not see "Announcement_2"
		And I should see "Announcment 1"
		
			

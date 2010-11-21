Feature: User Manegement
  In order to manage users
  As an admin 
  I want to see a users list and change user properties
  
  Background:
    Given the following activated users exists
      | name         | email                    | 
      | Alice Hunter | alice.hunter@regedor.com |
      | Bob Hunter   | bob.hunter@regedor.com   |
    And the following user records
      | name     | email                    | 
      | Jonh Doe | jonh.doe@regedor.com     |
  
	@auth
  Scenario: If I am not logged in I should not see the administration link
    Given I am not logged in
    Then I should not see "Administration"
  
  @auth
  Scenario: If I am not an admin I should not see the administration link
    Given I am logged in as "alice.hunter@regedor.com"
    Then I should not see "Administration"
	
	@auth
  Scenario: If I am an admin I should be able to access the administration panel
    Given I am logged in as admin
    When I follow "Administration"
		Then I should see "now viewing the Administration dashboard"
		
	@admin
	Scenario: I want to create a new announcement
	  Given I am logged in as admin
		And I follow "Administration"
		Then I should see "now viewing the Administration dashboard"
	  And I follow "Announcements"
	  Then I should see "Display Announcements"
		And I press "New Announcements"
   

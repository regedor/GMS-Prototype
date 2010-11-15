Feature: Users Manegement
  In order to manage users
  As an admin 
  I want see a users list and change user properties
  
  Background:
    Given the following activated users exists
      | name         | email                    | 
      | Alice Hunter | alice.hunter@regedor.com |
      | Bob Hunter   | bob.hunter@regedor.com   |
    And the following user records
      | name     | email                    | 
      | Jonh Doe | jonh.doe@regedor.com     |
    
  Scenario: If I am not logged in I should not see the administration link
    Given I am not logged in
    Then I should not see "Administration"
  
  Scenario: If I am not an admin I should not see the administration link
    Given I am logged in as "alice.hunter@regedor.com"
    Then I should not see "Administration"
##Given I go to admin users list 
##Then I should not see a table

  Scenario: 
    Given I am logged in as admin
    When I follow "Administration"
	And I follow "Users"
    Then I should see a table
    And I should see "alice.hunter@regedor.com"
    And I should see "bob.hunter@regedor.com"
    And I should see "jonh.doe@regedor.com"
    And I should see "root@example.com"
   

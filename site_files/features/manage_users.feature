Feature: User Management System
  In order to manage users
  As an admin
  I want to see a users list and change user properties

  Background:
    Given the DB has been initialized
    Given the following activated users exist
      | name | email          | role_id |
      | Root | rute@simon.com | 1       |
      | User | user@simon.com | 3       |

  @auth
  Scenario: If I am not logged in I should not see the administration link
    Given I am not logged in
    Then I should not see "Administration"

  @auth
  Scenario: If I am not an admin I should not see the administration link
    Given I am logged in as "rute@simon.com"
    Then I should not see "Administration"

  @auth
  Scenario: If I am an admin I should be able to access the administration panel
    Given I am logged in as admin
    When I follow "Administration"
    Then I should see "now viewing the Administration dashboard"

  Scenario: I am logged in as an admin and I want to list users
    Given I am logged in as admin
    When I follow "Administration"
    Then I follow "System"
    And I follow "Users"
    Then I should see "Root"
    And I should see "User"

  Scenario: I signed up and as an admin I want to check if the new user exists
    Given I am not logged in
    And I am on the homepage
    When I follow "Sign Up"
    And I fill in "Email" with "test@simon.com"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Register account"
    Given I am logged in as admin
    When I follow "Administration"
    And I follow "System"
    And I follow "Users"
    Then I should see "test@simon.com"

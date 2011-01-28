Feature: User Management System

  Background:
    Given the DB has been initialized

  @auth @admin
  Scenario: If I am not logged in, I should not see the administration link
    Given I am not logged in
    Then I should not see "Administration"

  @auth @admin
  Scenario: If I am not an administrator, I should not see the administration link
    Given I am logged in as a user
    Then I should not see "Administration"

  @auth @admin
  Scenario: If I am an administrator, I should be able to access the administration panel
    Given I am logged in as an administrator
    Then I should see "Administration"
    When I follow "Administration"
    Then I should see "now viewing the Administration dashboard"

  @admin @users
  Scenario: I am logged in as an administrator and I want to see a list of users
    Given I am logged in as an administrator
    When I follow "Administration"
    Then I follow "System"
    And I follow "Users"
    Then I should see "root"
    And I should see "user"

  @auth @admin @users
  Scenario: I signed up and as an administrator, I want to check if the new user exists
    Given I am not logged in
    And I am on the homepage
    When I follow "Sign up"
    And I fill in "Email" with "test@simon.com"
    And I fill in "Password" with "password"
    And I fill in "Password confirmation" with "password"
    And I press "Register account"
    Given I am logged in as an administrator
    When I follow "Administration"
    And I follow "System"
    And I follow "Users"
    Then I should see "test@simon.com"

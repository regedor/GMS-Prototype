Feature: Authentication Management System

  Background:
    Given the DB has been initialized
    And I18n is set to english
    And the following activated user exists
      | name | email          |
      | user | user@simon.com |

  @auth
  Scenario: I am not logged in and I want to create an account, confirm it and log in
    Given I am not logged in
    And I am on the homepage
    When I follow "Sign up"
    And I fill in "Email" with "example@email.com"
    And I fill in "Password" with "SuperPass"
    And I fill in "Password confirmation" with "SuperPass"
    Then I press "Register account"
    And I should see "Your account has been created."
    And "example@email.com" should receive an email
    When I open the email
    Then I should see "Thank you for creating an account!" in the email body
    When I click the link in the email
    Then I should see "Your account has been activated. Please login."
    When I fill in "Email" with "example@email.com"
    And I fill in "Password" with "SuperPass"
    And I press "Sign In"
    Then I should see "Login successful"
    And I should see "Your last login was"

  @auth
  Scenario: I am not logged in and I want to reset my password and log in with the new one
    And I am not logged in
    And I am on the homepage
    When I follow "Sign in"
    And I follow "I forgot my password"
    And I fill in "Email" with "user@simon.com"
    Then I press "Reset my password"
    And I should see "Instructions to reset your password have been emailed to you"
    And "user@simon.com" should receive an email
    When I open the email
    And I click the link in the email
    Then I should see "A request to reset your password has been made" in the email body
    When I click the link in the email
    And I fill in "Email" with "user@simon.com"
    And I fill in "New Password" with "NewSuperPass"
    And I fill in "Password confirmation" with "NewSuperPass"
    And I press "Update password and log in"
    Then I should see "Password successfully updated" 
    Then I should see "Your last login was"
    Then I should see "Sign out"
    When I follow "Sign out"
    Then I should see "Logout successful"
    And I am on the homepage
    Then I should see "Sign in"
    When I follow "Sign in"
    And I fill in "Email" with "user@simon.com"
    And I fill in "Password" with "NewSuperPass"
    And I press "Sign in"
    Then I should see "Login successful"
    And I should see "Your last login was"

  @auth @openid
  Scenario: I am not logged in and I want to sign up through OpenID and log in
    Given I am not logged in
    And I am on the homepage
    When I follow "Sign up"
    And I fill in "Sign up using OpenID" with "http://localhost:1123/john.doe?openid.success=true"
    And I press "Register account"
    And I receive a response from the OpenID Server
    Then I should see "Your account has been created."
    And "jhon@doe.com" should receive an email
    When I open the email
    Then I should see "Thank you for creating an account!" in the email body
    When I click the link in the email
    Then I should see "Your account has been activated. Please login."
    When I fill in "Sign in using OpenID" with "http://localhost:1123/john.doe?openid.success=true"
    And I press "Sign in"
    Then I should see "You are being redirected"

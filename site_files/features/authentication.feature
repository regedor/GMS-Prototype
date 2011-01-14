Feature: Authentication System
  In order to use the web site
  As an user
  I want to be able to login, logout, and create accounts

  Background:
    Given the DB has been initialized
    Given I18n is set to english

  @auth
  Scenario: Create an account, confirm and login
    Given I am not logged in
    And I am on the homepage
    When I follow "Sign Up"
    And I fill in "Email" with "example@email.com"
    And I fill in "Password" with "SuperPass"
    And I fill in "Password Confirmation" with "SuperPass"
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
  Scenario: Reset password, and login
    Given the following activated users exist
      | name     | email                |
      | Jonh Doe | jonh.doe@regedor.com |
    And I am not logged in
    And I am on the homepage
    When I follow "Sign In"
    And I follow "I forgot my password"
    And I fill in "Email" with "jonh.doe@regedor.com"
    Then I press "Reset my password"
    And I should see "Instructions to reset your password have been emailed to you"
    And "jonh.doe@regedor.com" should receive an email
    When I open the email
    And I click the link in the email
    Then I should see "A request to reset your password has been made" in the email body
    When I click the link in the email
    And I fill in "Email" with "jonh.doe@regedor.com"
    And I fill in "New Password" with "NewSuperPass"
    And I fill in "Password Confirmation" with "NewSuperPass"
    And I press "Update password and log in"
    Then I should see "Password successfully updated" 
    Then I should see "Your last login was"
    Then I should see "Sign Out"
    When I follow "Sign Out"
    Then I should see "Logout successful"
    And I am on the homepage
    Then I should see "Sign In"
    When I follow "Sign In" 
    And I fill in "Email" with "jonh.doe@regedor.com"
    And I fill in "Password" with "NewSuperPass"
    And I press "Sign in"
    Then I should see "Login successful"
    And I should see "Your last login was"

  @openid
  @auth
  Scenario: Sign up with Open ID and Log in
    Given I am not logged in
    And I am on the homepage
    When I follow "Sign Up"
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
    And I press "Sign In"
    Then I should see "You are being redirected"

#  Scenario: Create an account, confirm and login (Portuguese version)
#    Given I am not logged in
#    And I am on the homepage
#    When I follow "Sign Up"
#    And I fill in "Email" with "example@email.com"
#    And I fill in "Password" with "SuperPass"
#    And I select "Português" from "Language" 
#    And I fill in "Password Confirmation" with "SuperPass"
#    Then I press "Register"
#    And I should see "A sua conta foi criada com sucesso."
#    And "example@email.com" should receive an email
#    When I open the email
#    Then I should see "Obrigado" in the email body
#    When I click the link in the email
#    Then I should see "A sua conta foi activada"
#    Then I follow "Sign In"
#    When I fill in "Email" with "example@email.com"
#    And I fill in "Password" with "SuperPass"
#    And I press "Iniciar Sessão"
#    Then I should see "Sessão iniciada"

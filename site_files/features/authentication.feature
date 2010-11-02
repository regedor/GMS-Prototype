Feature: Authentication System
  In order to use the web site
  As an user
  I want to be able to login, logout, and create accounts

  Backgroud:
    Given I18n is set to english  

  Scenario: Create an account, confirm and login
    Given I am not logged in
    And I am on the homepage
    When I follow "Sign Up"
    And I fill in "Email" with "example@email.com"
    And I fill in "Password" with "SuperPass"
    And I fill in "Password Confirmation" with "SuperPass"
    Then I press "Register"
    And I should see "Your account has been created."
    And "example@email.com" should receive an email
    When I open the email
    Then I should see "Thank you for creating an account!" in the email body
    When I click the link in the email
    Then I should see "Your account has been activated. Please login."
    When I fill in "Email" with "example@email.com"
    And I fill in "Password" with "SuperPass"
    And I press "Sign"
    Then I should see "Login successful"


  Scenario: Reset password, and login
    Given the following activated users exists 
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
    And I should see "Logout"
    When I follow "Logout"
    Then I should see "Logout successful"
    When I follow "Login" 
    And I fill in "Email" with "jonh.doe@regedor.com"
    And I fill in "Password" with "NewSuperPass"
    And I press "Login"
    Then I should see "Login successful"


  Scenario: Create an account, confirm and login (Portuguese version)
    Given I am not logged in
    And I am on the homepage
    When I follow "Sign Up"
    And I fill in "Email" with "example@email.com"
    And I fill in "Password" with "SuperPass"
    And I select "Português" from "Language" 
    And I fill in "Password Confirmation" with "SuperPass"
    Then I press "Register"
    And I should see "A sua conta foi criada com sucesso."
    And "example@email.com" should receive an email
    When I open the email
    Then I should see "Obrigado" in the email body
    When I click the link in the email
    Then I should see "A sua conta foi activada"
    Then I follow "Sign In"
    When I fill in "Email" with "example@email.com"
    And I fill in "Password" with "SuperPass"
    And I press "Iniciar Sessão"
    Then I should see "Sessão iniciada"

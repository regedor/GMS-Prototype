Feature: Manage Projects
  In order to manage projects
  As a admin
  I want to create and manage to-dos

  Scenario: Edit To-Do
    Given I have a to-do named Do Stuff from 20/11/2011
    When I click edit
    Then I should see the date 20/11/2011
    And I should see the name Do Stuff
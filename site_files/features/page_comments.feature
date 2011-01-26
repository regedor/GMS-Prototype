Feature: Page Management System

  Background:
    Given the DB has been initialized
    And I18n is set to english
    And the following pages exist
      | title | body      |
      | page  | test page |

  @admin @pages @comments
  Scenario: If I am an administrator, I should be able to see the author and content of comments
    Given I am logged in as an administrator
    When I follow "Administration"
      And I follow "Website"
      And I follow "Pages"
      And I follow "Comments" within "#as_admin__pages-list-1-row"
      And I follow "New comment"
      And I fill in "Author" with "Gauss"
      And I fill in "Body" with "1 + 2 + 3 ... + n = n * (n + 1) / 2"
      And I press "Create"
      Then I should see "Gauss"
      And I should see "1 + 2 + 3 ... + n = n * (n + 1) / 2"

  @admin @pages @comments
  Scenario: If I am an administrator, I should not be able to see removed comments
    Given I am logged in as an administrator
    When I follow "Administration"
    And I follow "Website"
    And I follow "Pages"
    And I follow "Comments" within "?"
    Then I should see "Comment X"
    When I press Remove within ...
    And I accept
    And I follow "Website"
    And I follow "Static Pages"
    And I follow "Comments" within "?"
    Then I should not see "Comment X"

  @admin @pages @comments
  Scenario: If I am logged in as admin
    Given I am logged in as an administrator
    When I follow "Administration"
    And I follow "Website"
    And I follow "Pages"
    And I follow "Comments" within "?"
    Then I should see "Comment A"
    And I should see "Comment B"
    And I should see "Remove Comment"

  @pages @comments
  Scenario: If I am logged in as admin
    Given I am logged in as a user
    When I follow ...
    And I follow "Pages"
    And I follow "Comments" within "?"
    Then I should see "Comment A"
    And I should see "Comment B"
    And I should not see "Remove Comment"

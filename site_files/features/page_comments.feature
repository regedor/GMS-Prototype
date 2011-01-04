Feature:
  In order manage page comments
  As a admin
  I want to see comments content, author and management options

Background:
  Given I18n is set to english
  And the following pages exists

  @admin
  Scenario: If I am an admin I should be able to see the content and author of the comments
    Given I am logged in as admin
    When I follow "Administration"
      And I follow "Website"
      And I follow "Static Pages"
      And I follow "Comments" within "#as_admin__pages-list-1-row"
      And I follow "New comment"
      And I fill in "Author" with "Gauss"
      And I fill in "Body" with "1 + 2 + 3 ... + n = n * (n + 1) / 2"
      And I press "Create"
      Then I should see "Gauss"
      And I should see "1 + 2 + 3 ... + n = n * (n + 1) / 2"
      

  Scenario: If I am an admin I should not be able to see removed comments
    Given I am logged in as admin
    When I follow "Administration"
      And I follow "Website"
      And I follow "Static Pages"
      And I follow "Comments" within "?"
      Then I should see "Comment X"
    When I press Remove within ...
      And I accept
      And I follow "Website"
      And I follow "Static Pages"
      And I follow "Comments" within "?"
      Then I should not see "Comment X"

  Scenario: If I am logged in as admin
    Given I am logged in as admin
    When I follow "Administration"
      And I follow "Website"
      And I follow "Static Pages"
      And I follow "Comments" within "?"
      Then I should see "Comment A"
      And I should see "Comment B"
      And I should see "Remove Comment"

  Scenario: If I am logged in as admin
    Given I am logged in as an user
    When I follow ...
      And I follow "Static Pages"
      And I follow "Comments" within "?"
      Then I should see "Comment A"
      And I should see "Comment B"
      And I should not see "Remove Comment"


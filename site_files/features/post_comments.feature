Feature: Post Management System

  Background:
    Given the DB has been initialized
    And I18n is set to english
    And the following post exists
      | title | body      | published_at |
      | post  | test post | yesterday    |

  Scenario: If I am an administrator, I should be able to see the author and content of comments
    Given I am logged in as an administrator
    When I follow "Administration"
    And I follow "Website"
    And I follow "Posts"
    And I follow "Comments" within "#as_admin__posts-list-1-row"
    And I follow "New Comment"
    And I fill in "Author" with "Euler"
    And I fill in "Body" with "e ^ (i * a) = cos a + i * sin a"
    And I press "Create"
    And I follow "Website"
    And I follow "Posts"
    And I follow "Comments" within "#as_admin__posts-list-1-row"
    Then I should see "Euler"
    And I should see "e ^ (i * a) = cos a + i * sin a"    

  Scenario: If I am logged in as admin then I should be able to remove comments
    Given I am logged in as an administrator
    When I follow "Administration"
    And I follow "Website"
    And I follow "Posts"
    And I follow "Comments" within "#as_admin__posts-list-1-row"
    And I follow "New Comment"
    And I fill in "Author" with "Golum"
    And I fill in "Body" with "My precious"
    And I press "Create"
    Then I should see "Golum"
    And I should see "My precious"  
    When I follow "Website"
    And I follow "Posts"
    And I follow "Comments" within "#as_admin__posts-list-1-row"
    And I follow "Delete"
    And I accept
    Then I should not see "Golum"

  Scenario: If I am logged in as admin then I should be able to see the "Remove Comment" link
    Given I am logged in as an administrator
    When I follow "Administration"
    When I follow "Website"
    And I follow "Post"
    And I follow "Comments" within "#as_admin__posts-list-1-row"
    Then I should see "Comment a"
    And I should see "Comment b"
    And I should see "Remove comment"

  Scenario: If I am logged in as an user then I should not be able to see the "Remove Comment" link
    Given I am logged in as a user
    When I follow "Website"
    And I follow "Post"
    And I follow "Comments" within "#as_admin__posts-list-1-row"
    Then I should see "Comment a"
    And I should see "Comment b"
    And I should not see "Remove comment"

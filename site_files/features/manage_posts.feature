Feature: Post Management System

  Background:
    Given the DB has been initialized
    And I18n is set to english
    And the following posts exists
      | title  | body        | published_at |
      | post_1 | test post 1 | yesterday    |
      | post_2 | test post 2 | now          |
    And I am logged in as an administrator

  @admin @posts
  Scenario: As an administrator, I want to see a list of posts
    When I follow "Administration"
    And I follow "Website"
    And I follow "Posts"
    Then I should see "post_1"
    And I should see "test post 1"
    And I should see "post_2"
    And I should see "test post 2"

  @admin @posts
  Scenario: As an administrator, I want to create a new post
    When I follow "Administration"
    And I follow "Website"
    And I follow "Posts"
    And I follow "New Post"
    And I fill in "Title" with "Lorem Ipsum"
    And I fill in "Body" with "Lorem Ipsum"
    And I fill in "Tag List" with "new tag"
    And I press "Save"
    Then the flash "info" should contain "Created Lorem Ipsum"
    #Then I should see "Created Lorem Ipsum"
    When I follow "Posts"
    Then I should see "Lorem Ipsum"
    # Check for tags

  #javascript
  @admin @posts
  Scenario: As an administrator, I want to delete a post
    When I follow "Administration"
    And I follow "Website"
    And I follow "Posts"
    When I follow "Delete" for posts whose title is "post_2"
    And I press "Delete"
    Then I should not see "test post 2"
    And I should see "post_1"
    # Check for tags

  #javascript
  @admin @posts
  Scenario: As an administrator, I don't want to delete a post
    When I follow "Administration"
    And I follow "Website"
    And I follow "Posts"
    When I follow "Delete" for posts whose title is "post_2"
    And I press "Cancel" #follow?
    Then I should see "test post 2"
    And I should see "test post 1"
    # Check for tags

  #javascript
  @admin @posts
  Scenario: As an administrator, I want to edit the title of a post
    When I follow "Administration"
    And I follow "Website"
    And I follow "Posts"
    Then I should see "Alice Hunter"
    When as admin I follow "Edit" for posts whose title is "Alice Hunter"
    And I fill in "Title" with "The Huntress"
    And I press "Save"
    Then I should see "Updated The Huntress"
    When I follow "Posts"
    Then I should not see "Alice Hunter"
    And I should see "The Huntress"

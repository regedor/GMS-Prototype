Feature: Posts Manegement
	In order to posts announcements
	As an admin 
	I want to see the posts list and change user properties

	Background:
		Given I18n is set to english  
    And the following posts exists
      | title             | body        | published_at |
      | Alice Hunter      | Is hot      | yesterday    |
      | Helena Secretária | anda por ai | now          |
		And I am logged in as admin

	@admin
	Scenario: I want to see a list of existing posts
		When I follow "Administration"
		Then I should see "Simon Administration"
		And I follow "Website"
		And I follow "Posts"
		Then I should see "Alice Hunter"
		And I should see "Is hot"
		And I should see "Helena Secretária"
		And I should see "anda por ai"
		
	Scenario: I want to create a new post
	  When I follow "Administration"
	  Then I should see "Simon Administration"
		And I follow "Website"
		And I follow "Posts"
	  And I follow "New Post"
    And I fill in "Title" with "Lorem Ipsum"
		And I fill in "Body" with "Lorem Ipsum"
		And I fill in "Tag list" with "new tag"
		And I press "Save"
		Then I should see "Created post 'Lorem Ipsum'"
		When I follow "Posts"
		Then I should see "Lorem Ipsum"
		# Check for tags
		
	Scenario: I want to delete an existing post
  	When I follow "Administration"
  	Then I should see "Simon Administration"
		And I follow "Website"
		And I follow "Posts"
		When I follow "Delete" for posts whose title is "Helena Secretária"
		Then I should not see "Helena Secretária"
		# Check for tags
	
	

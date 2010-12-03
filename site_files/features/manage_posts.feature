Feature: Posts Manegement
	In order to posts announcements
	As an admin 
	I want to see the posts list and change user properties

	Background:
		Given I18n is set to english  
    And the following posts exists
      | title             | body                          | published_at |
      | Alice Hunter      | Is an actress                 | yesterday    |
      | Helena Secretária | Is the department secretary | now          |
		And I am logged in as admin

	@admin
	Scenario: I want to see a list of existing posts
		When I follow "Administration"
		Then I should see "Simon Administration"
		And I follow "Website"
		And I follow "Posts"
		Then I should see "Alice Hunter"
		And I should see "Is an actress"
		And I should see "Helena Secretária"
		And I should see "Is the department secretary"
		
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
	
	@selenium
	Scenario: I want to delete an existing post
  	When I follow "Administration"
  	Then I should see "Simon Administration"
		And I follow "Website"
		And I follow "Posts"
		When as admin I follow "Delete" for posts whose title is "Helena Secretária"
		And I press "OK"
		Then I should not see "Helena Secretária"
		And I should see "Alice Hunter"
		# Check for tags
		
		@selenium
		Scenario: I don't want to delete an existing post
	  	When I follow "Administration"
	  	Then I should see "Simon Administration"
			And I follow "Website"
			And I follow "Posts"
			When as admin I follow "Delete" for posts whose title is "Helena Secretária"
			And I press "Cancel"
			Then I should see "Helena Secretária"
			And I should see "Alice Hunter"
			# Check for tags
	
	Scenario: I want to edit the title of a post
		When I follow "Administration"
		Then I should see "Simon Administration"
		And I follow "Website"
		And I follow "Posts"
		Then I should see "Alice Hunter"
		When as admin I follow "Details" for posts whose title is "Alice Hunter"
		And I fill in "Title" with "The Huntress"
		And I press "Save"
		Then I should see "Updated post"
		When I follow "Posts"
		Then I should not see "Alice Hunter"
		And I should see "The Huntress"
		
    
		

	
	
	

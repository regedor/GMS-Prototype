Feature: Announcements Management System

  Background:
    Given the DB has been initialized
    And the following announcements exist:
      | title          | message             | starts_at                       | ends_at                         |
      | announcement_1 | test announcement 1 | Mon, 22 Nov 2010 16:21:00 +0000 | Fri, 26 Nov 2010 16:21:00 +0000 |
      | announcement_2 | test announcement 2 | Fri, 26 Nov 2010 16:21:00 +0000 | Tue, 30 Nov 2010 16:22:00 +0000 |

  @admin @announcements
  Scenario: If I am an administrator, I shoul be able to see the content of announcements
    Given I am logged in as an administrator
    When I follow "Administration"
    And I follow "Website"
    And I follow "Announcements"
    And I should see "Announcement_1"
    And I should see "Announcement 2"

  @admin @announcements
  Scenario: If I am an administrator, I should be able to see the content of the announcement after inserting it
    Given I am logged in as an administrator
    When I follow "Administration"
    And I follow "Website"
    And I follow "Announcements"
    And I follow "New Announcement"
    And I fill in the following:
      | Title      | Announcement 3 |
      | Message    | Test on annoncement 2 |
      | Start Date | Fri, 26 Nov 2010 16:21:00 +0000 |
      | End Date   | Tue, 30 Nov 2010 16:22:00 +0000 |
    When I press "Create"
    Then I should see "Announcement 3"

  #javascript
  @admin @announcements
  Scenario: If I am an administrator, I should be able to see the content of announcements after deleting an announcement
    Given I am logged in as an administrator
    When I follow "Administration"
    And I follow "Website"
    And I follow "Announcements"
    And I delete the "Announcement_2"
    Then I should see a JS "Are You Sure"
    And I should not see "Announcement_2"
    And I should see "Announcment 1"

require 'test_helper'

class Admin::ToDosControllerTest < ActionController::TestCase

  include Capybara

    setup do
      @project = projects(:mega)

      @todo = ToDo.create :description => "Do something",
                          :due_date => DateTime.new(2010,2,7)
    end

    # Replace this with your real tests.
    test "dates are shown correctly in edit form" do
      visit admin_project_to_do_lists_path(@project)

      assert_equal(10,Project.all.size)
      page.has_css?("#cenaimpossible")
      #click_link("edit_3")
      page.has_css?("form [class='formatastic todo']")
    end
end
require 'test_helper'

class ToDoTest < ActionController::IntegrationTest
  include Capybara

  setup do

  end

  test "dates are shown correctly in edit form" do    
    login_as_root
    
    to_do = Factory.create(:to_do, :due_date => DateTime.new(2010,10,1))
    list = to_do.to_do_list
    project = list.project
  
    visit admin_project_to_do_lists_path(project)
    page.find("#edit_#{to_do.id}").click
    sleep(1)
    assert_equal("01/10/2010",page.find("#todo_due_date_#{to_do.id}")["value"])  
    
    logout
  end

  test "datepicker shows up after multiple creations without refresh" do   
    login_as_root 
    to_do = Factory.create(:to_do, :due_date => DateTime.new(2010,10,1))
    list = to_do.to_do_list
    project = list.project
    
    visit admin_project_to_do_lists_path(project)
    page.find("#add_button-#{list.id} .add_link").click
    sleep(1)
    page.find("#todo_due_date_#{list.id}").click
    assert page.find("#ui-datepicker-div").visible?
    
    new_todo = Factory.build(:to_do, :to_do_list => list)
    no_of_todos = ToDo.all.size
    fill_in("Enter a new to-do item", :with => new_todo.description)
    page.find("li.commit .add_todo").click
    sleep(1)
    
    page.find("#todo_due_date_#{list.id}").click
    assert page.find("#ui-datepicker-div").visible?, "Can't see the datepicker"
    
    logout
  end

  private

  def login_as_root
    admin = Factory.create(:root_user)

    visit "/user/session/new"
    fill_in('Email', :with => admin.email)
    fill_in('Password', :with => admin.password)
    click_button("user_session_submit")
  end
  
  def logout
    click_link("Sign out")
  end


end

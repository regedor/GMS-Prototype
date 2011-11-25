require 'test_helper'

class UserTest < ActiveSupport::TestCase
   test "name must return the email if there is no name" do
     user = Factory.build(:nameless_user)
     assert_equal(user.email,user.name)
   end
   
   test "name must return the name if there is a name" do
     user = Factory.build(:root_user, :name => "Name")
     assert_equal("Name",user.name)
   end
   
   test "name must return nil or blank if there is no name and just_name is true" do
     user = Factory.build(:nameless_user)
     assert !user.name(true).present?
   end
    
    test "name must return the name if there is a name and just_name is true" do
      user = Factory.build(:root_user, :name => "Name")
      assert_equal("Name",user.name(true))
    end
end
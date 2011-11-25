require 'test_helper'

class Admin::ToDosControllerTest < ActionController::TestCase

    setup do
      
    end

    test "mail is sent to responsible after todo creation" do
      post :create, :to_do => {
        :user_id => noel.id,
        :yesterday => "I did stuff",
        :today => "I'll do stuff"
      }
    end
end
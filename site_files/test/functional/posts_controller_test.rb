require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include ActionController::Assertions::SelectorAssertions


    setup do
      
    end

    test "if event is not subscribable, user cannot see subscription" do
      event = Factory.create(:event, :subscribable => false)
      post = Factory.create(:valid_post)
      event.post = post
      post.event = event
      
      p post.slug
      
      get :show, :day => post.published_at.send(:day), 
                 :month => post.published_at.send(:month),
                 :year => post.published_at.send(:year), 
                 :slug => post.slug
      assert_response :success
      assert_select ".social-buttons"
    end
    
    test "if event is subscribable, user must see subscription" do
      event = Factory.create(:event, :subscribable => true)
      post = Factory.create(:valid_post)
      event.post = post
      post.event = event
      
      p post.slug
      
      get :show, :day => post.published_at.send(:day), 
                 :month => post.published_at.send(:month),
                 :year => post.published_at.send(:year), 
                 :slug => post.slug
      assert_response :success
      assert css_select(".social-buttons")
      assert css_select(".event-body")
    end
end
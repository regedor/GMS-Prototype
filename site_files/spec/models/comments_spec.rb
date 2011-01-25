require File.dirname(__FILE__) + '/../spec_helper'

module CommentSpecHelper

  def valid_comment_attributes
    {
      :body => 'Um comentario giro!',
      :user_id => 1
    }
  end

  def valid_created_attribute
    {
      :created_at => '2010-08-26 18:41:08'
    }
  end

end

module PostSpecHelper

  def valid_post_attributes
    {
      :title => 'Novo post',
      :body => 'Um post novo',
    }
  end

end

module UserSpecHelper

  def valid_user_attributes
    {
      :email => 'root@simon.com',
      :password => 'simonroot',
      :password_confirmation => 'simonroot',
      :name => 'Root'
    }
  end

end

module PageSpecHelper

  def valid_page_attributes
    {
      :title => 'A nossa página',
      :body => 'Gosta da nossa nova página? Deixe o seu comentário',
      :has_comments => 'true',
      :show_in_navigation => false
    }
  end

end
describe Comment do

  include CommentSpecHelper
  include PostSpecHelper
  include UserSpecHelper
  include PageSpecHelper

  before(:all) do
    puts User.find(:all)
    @post = Post.new
    @user = User.new
    @page = Page.new
    @post.attributes = valid_post_attributes
    @user.attributes = valid_user_attributes
    @page.attributes = valid_page_attributes
    @post.save!
    @user.save!
    @page.save!
  end

  after(:all) do
    @post.destroy
    @user.destroy
    @page.destroy
  end

  before do
    @comment = Comment.new
  end

  ## valid?
  it "new comment for post should be valid" do
    @comment.attributes = valid_comment_attributes
    @comment.user = @user
    @comment.commentable = @post
    @comment.should be_valid
  end

  ## valid?
  it "new comment for page should be valid" do
    @comment.attributes = valid_comment_attributes
    @comment.user = @user
    @comment.commentable = @page
    @comment.should be_valid
  end

  ## Creates new comment with filter
  it "should be able to create new comment from params" do
    @comment.attributes = valid_comment_attributes
    @comment.commentable = @post
    @comment.save!
    @comment.id = nil
    Comment.new_with_filter(@comment.attributes).should eql(@comment)
  end

  ## Creates new comment with filter
  it "should be able to build preview from params" do
    @comment.attributes = valid_comment_attributes
    @comment.commentable = @post
    @comment.save!
    @comment.id = nil
    Comment.build_for_preview(@comment.attributes).should eql(@comment)
  end

  ## Find recent comments
  it "finding recent posts should return the most recent posts" do
    @comment2 = Comment.new
    @comment3 = Comment.new
    @comment.attributes = valid_comment_attributes.merge(valid_created_attribute)
    @comment.commentable = @post
    @comment2.attributes = {:user_id => 1, :body => 'body do segundo comentario', :commentable => @post}
    @comment3.attributes = {:user_id => 1, :body => 'este e o body do terceiro comentario', :commentable => @page}

    @comment.save!
    @comment2.save!
    @comment3.save!

    @results = Comment.find_recent({:limit => 2})
    @results.should include(@comment2,@comment3)
    @results.should_not include(@comment)
  end

describe Post do
end

describe User do
end

describe Page do
end

end

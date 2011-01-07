require File.dirname(__FILE__) + '/../spec_helper'

module CommentSpecHelper

  def valid_comment_attributes
    {
      :author => 'Regedor',
      :body => 'Um comentario ao novo post',
      :author_url => 'http://www.regedor.com',
      :author_email => 'miguelregedor@gmail.com',
      :post_id => 1
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

describe Comment do

  include CommentSpecHelper
  include PostSpecHelper

  before(:all) do
    @post = Post.new
    @post.attributes = valid_post_attributes
    @post.save!
  end

  before do
    @comment = Comment.new
  end

  ## valid?
  it "new comment should be valid" do
    @comment.attributes = valid_comment_attributes
    @comment.should be_valid
  end

  ## destroy

  ## Belongs to a post
  it "should belong to a post" do
    should belong_to :post
  end

  ## Erasing author and author_email fields
  it "should reset author and author_email fields" do
    @comment.attributes = valid_comment_attributes

    @comment.author_url.should_not be_blank
    @comment.author_email.should_not be_blank

    @comment.blank_openid_fields

    @comment.author_url.should be_blank
    @comment.author_email.should be_blank
  end

  ## Checks if OpenID is required
  it "should check if OpenID authentication is required" do
    @comment.attributes = valid_comment_attributes
    @comment.requires_openid_authentication?.should be_false
    @comment.author = 'miguelregedor@gmail.com'
    @comment.requires_openid_authentication?.should be_true
  end

  ## Creates new comment with filter
  it "should be able to create new comment from params" do
    @comment.attributes = valid_comment_attributes
    @comment.save!
    @comment.id = nil
    Comment.new_with_filter(@comment.attributes).should eql(@comment)
  end

describe Post do
end

end

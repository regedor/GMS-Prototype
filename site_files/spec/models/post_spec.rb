require File.dirname(__FILE__) + '/../spec_helper'

module PostSpecHelper

  def valid_post_attributes
    {
      :title => 'Novo post',
      :body => 'Um post novo',
    }
  end

  def valid_published_attribute
    {
      :published_at => '2010-08-26 18:41:08'
    }
  end

end

describe Post do

  include PostSpecHelper

  before do
    @post = Post.new
  end

  ## valid?
  it "new post should be valid" do
    @post.attributes = valid_post_attributes
    @post.should be_valid
  end

  ## destroy

  ## has_many comments
  it "should have many comments" do
    should have_many :comments
  end

  ## Validate published status
  it "validating published status should raise error if !published?" do
    @post.attributes = valid_post_attributes
    @post.validate_published_at_natural.should raise_error()
  end

  ## Validate published status
  it "validating published status should be null if published?" do
    @post.attributes = valid_published_attribute.merge(valid_post_attributes)
    @post.validate_published_at_natural.should be_nil
  end

  ## Validate slug
  it "slug should be generated on saving" do
    @post.attributes = valid_post_attributes
    @post.save!
    @post.slug.should == 'novo-post'
  end

  ## Buils preview
  it "preview build should generate slug, set dates and apply filter" do
    @post.attributes = valid_post_attributes
    @novo = Post.build_for_preview(@post.attributes)
    @novo.slug.should == 'novo-post'
    @novo.edited_at.should_not be_nil
    @novo.published_at.should_not be_nil
  end

  ## Find recent posts
  it "finding recent posts should return the most recent posts" do
    @post2 = Post.new
    @post3 = Post.new
    @post.attributes = valid_post_attributes.merge(valid_published_attribute)
    @post2.attributes = {:title => 'segundo post', :body => 'body do segundo post'}
    @post3.attributes = {:title => 'O terceiro post', :body => 'este e o body do terceiro post'}

    @post.save!
    @post2.save!
    @post3.save!

    @results = Post.find_recent({:limit => 2, :conditions => ['published_at <= ?', Time.zone.now]})
    @results.should include(@post2,@post3)
    @results.should_not include(@post)
  end

  ## Find by permalink
  it "finding from permalink should work" do
    @post.attributes = valid_post_attributes.merge(valid_published_attribute)
    @post.save!
    @post2 = Post.new
    @post2.attributes = {:title => 'segundo post', :body => 'body do segundo post'}
    @post2.save!
    
    time1 = @post.published_at
    time2 = Time.now

    Post.find_by_permalink(time1.year, time1.mon, time1.day, @post.slug).should == @post
    Post.find_by_permalink(time2.year, time2.mon, time2.day, @post2.slug).should == @post2
  end

end

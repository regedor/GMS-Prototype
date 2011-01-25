require File.dirname(__FILE__) + '/../spec_helper'

module PostSpecHelper

  def valid_post_attributes
    {
      :title => 'Novo post',
      :body => 'Um post novo'
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
    should have_many :approved_comments
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

  ## Setting attributes
  it "setting post attributes, should set cached_tag_list = \"\" if it's not explicitly set" do
    @post.cached_tag_list.should be_nil
    @post.attributes = valid_post_attributes
    @post.cached_tag_list.should eql("")
  end

  ## Generating tag list from a tag array
  it "should generate tag list from a tag array" do
    @post.tag_list = ['new','first','post']
    @post.tag_list.should eql(['new','first','post'])
  end

  ## Generating an option hash that only retrieves posts with the argument tags
  it "should generate an option hash to obtain posts with argument tags" do
    @post.attributes = valid_post_attributes
    @post2 = Post.new(valid_post_attributes)
    @post3 = Post.new(valid_post_attributes)
    @post.tag_list = ['um','dois','tres']
    @post2.tag_list = ['um','dois','quatro']
    @post3.tag_list = ['um','quatro','cinco']
    @post.save!
    @post2.save!
    @post3.save!

    @results = Post.find(:all,Post.tags_filter([1]))
    Post.find(:all,@results).should include(@post,@post2,@post3)

    @results = Post.find(:all,Post.tags_filter([1,2]))
    @results.should include(@post,@post2)
    @results.should_not include(@post3)

    @results = Post.find(:all,Post.tags_filter([1,3]))
    @results.should include(@post)
    @results.should_not include(@post2,@post3)

    @results = Post.find(:all,Post.tags_filter([1,4]))
    @results.should include(@post2,@post3)
    @results.should_not include(@post)

    @results = Post.find(:all,Post.tags_filter([2,4]))
    @results.should include(@post2)
    @results.should_not include(@post,@post3)

    @results = Post.find(:all,Post.tags_filter([5]))
    @results.should include(@post3)
    @results.should_not include(@post,@post2)

    @results = Post.find(:all,Post.tags_filter([1,2,3,4,5]))
    @results.should_not include(@post,@post2,@post3)
  end

end

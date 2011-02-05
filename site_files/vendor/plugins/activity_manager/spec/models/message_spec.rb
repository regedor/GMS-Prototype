require File.dirname(__FILE__) + '/../spec_helper'

describe Message do

  before do
    @message = Message.new
  end

  ## valid?
  it "new message should be valid" do
    @message.should be_valid
  end

  ## belongs_to :user
  it "should belong to a user" do
    should belong_to :user
  end

  ## belongs_to :category
  it "should belong to a category" do
    should belong_to :category
  end

  ## belongs_to :project
  it "should belong to a project" do
    should belong_to :project
  end

  ## has_many :messages
  it "should have many messages_comments" do
    should have_many :messages_comments
  end

  #FIXME
  ## before_save :apply_filter
  it "should call the apply_filter method" do
    @message.project_id = 1
    @message.user_id = 1
    @message.category_id = 1
    @message.title = "super title!"
    @message.body = "super message!"
    @message.save!
    #@message.should_receive(:apply_filter)
  end

end

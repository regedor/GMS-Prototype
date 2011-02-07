require File.dirname(__FILE__) + '/../spec_helper'

describe MessagesComment do

  before do
    @message = MessagesComment.new
  end

  ## valid?
  it "new messages comment should be valid" do
    @message.should be_valid
  end

  ## belongs_to :user
  it "should belong to a user" do
    should belong_to :user
  end

  ## belongs_to :message
  it "should belong to a message" do
    should belong_to :message
  end

  #FIXME
  ## before_save :apply_filter
  it "should call the apply_filter method" do
    @message.user_id = 1
    @message.message_id = 1
    @message.body = "super body!"
    @message.save!
    #@message.should_receive(:apply_filter)
  end

end

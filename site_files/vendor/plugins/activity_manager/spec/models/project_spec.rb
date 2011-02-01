require File.dirname(__FILE__) + '/../spec_helper'

describe Project do

  before do
    @project = Project.new
  end

  ## valid?
  it "new project should be valid" do
    @project.should be_valid
  end

  ## belongs_to :user
  it "should belong to a user" do
    should belong_to :user
  end

  ## belongs_to :blackboard
  it "should belong to a blackboard" do
    should belong_to :blackboard
  end

  ## has_and_belongs_to_many :groups
  it "should have and belong to many groups" do
    should have_and_belong_to_many :groups
  end

  ## has_and_belongs_to_many :users
  it "should have and belong to many users" do
    should have_and_belong_to_many :users
  end

  ## has_many :to_do_lists
  it "should have many ToDOLists" do
    should have_many :to_do_lists
  end

  ## has_many :messages
  it "should have many messages" do
    should have_many :messages
  end

end

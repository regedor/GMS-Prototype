require File.dirname(__FILE__) + '/../spec_helper'

describe ToDo do

  before do
    @todo = ToDo.new
  end

  ## valid?
  it "new post should be valid" do
    @todo.should be_valid
  end

  ## belongs_to :user
  it "should belong to a user" do
    should belong_to :user
  end

  ## belongs_to :user
  it "should belong to a to_do_list" do
    should belong_to :to_do_list
  end

end

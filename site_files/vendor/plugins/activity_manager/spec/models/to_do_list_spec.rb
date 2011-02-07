require File.dirname(__FILE__) + '/../spec_helper'

describe ToDoList do

  before do
    @todolist = ToDoList.new
  end

  ## valid?
  it "new ToDOList should be valid" do
    @todolist.should be_valid
  end

  ## belongs_to :project
  it "should belong to a project" do
    should belong_to :project
  end

  ## has_many :to_dos
  it "should have many ToDOs" do
    should have_many :to_dos
  end

end

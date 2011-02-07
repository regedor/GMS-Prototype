require File.dirname(__FILE__) + '/../spec_helper'

describe Category do

  before do
    @category = Category.new
  end

  ## valid?
  it "new category should be valid" do
    @category.should be_valid
  end

  ## has_many :messages
  it "should have many messages" do
    should have_many :messages
  end

end

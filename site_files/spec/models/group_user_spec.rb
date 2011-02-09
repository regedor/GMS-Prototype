require File.dirname(__FILE__) + '/../spec_helper'

describe GroupsUser do

  before do
  end
  
  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  it { should belong_to(:user) }

  it { should belong_to(:group) }
  
end

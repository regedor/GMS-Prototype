require File.dirname(__FILE__) + '/../spec_helper'

describe Group do

  before do
  end
  
  # ==========================================================================
  # Relationships
  # ==========================================================================

  it { should have_and_belong_to_many(:groups) }
  it { should have_and_belong_to_many(:direct_users) }

  # ==========================================================================
  # Validations
  # ==========================================================================
  
  it "should only accept unique name" do
    Factory.create(:valid_group)
    Factory.build(:valid_group).should validate_uniqueness_of( :name )
  end
  
  # ==========================================================================
  # Instance Methods
  # ==========================================================================
  
#  it "" do
#    g = Factory.create(:group)
#    g.subgroups.map(&:name).join(", ").should eql(g.subgroups_names)    
#  end

#  it "" do  
#    g = Factory.create(:group)
#    u = Factory.create(:valid_user)
#    u2 = Factory.create(:valid_user)
#    g.direct_users << u
#    g.direct_users << u2
#    (g.direct_users | subgroups.map(&:direct_users).flatten).should eql(g.all_users)
#  end
  
 
end

require File.dirname(__FILE__) + '/../spec_helper'

module GroupSpecHelper

  def valid_group_attributes
    {
      :name => 'Grupinho da Moda',
      :mailable => true
    }
  end

end

describe Group do

  include GroupSpecHelper

  before do
    @group = Group.new
  end

  ## valid?
  it "new group should be valid" do
    @group.should be_valid
  end

  ## deleted? = false
  #it "new group should not be deleted" do
  #  @group.should_not be_deleted
  #end

  ## destroy, deleted? = true
  #it "after destroying a group, group should be deleted" do
  #  @group.attributes = valid_group_attributes
  #  @group.destroy
  #  @group.should be_deleted
  #  @group.should_not be_authorized_for('show','edit','delete','list')
  #end

  ## destroy, subgroups.each.deleted? = true
  #it "after destroying a group, subgroups should be deleted" do
  #  @group.attributes = valid_group_attributes
  #  @group.save!
  #  @group2 = Group.new
  #  @group2.attributes = valid_group_attributes
  #  @group2.parent_group = @group
  #  @group2.save!
  #  @group.destroy
  #  @group2 = Group.find(@group2.id)
  #  @group2.should be_deleted
  #  @group2.should_not be_authorized_for('show','edit','delete','list')
  #end

  ## destroy, subgroups.each.deleted? = true
  #it "after destroying a group, subgroups should be deleted (2)" do
  #  @group.attributes = valid_group_attributes
  #  @group.save!
  #  @group2 = Group.new
  #  @group2.attributes = valid_group_attributes
  #  @group2.parent_group = @group
  #  @group2.save!
  #  @group3 = Group.new
  #  @group3.attributes = valid_group_attributes
  #  @group3.parent_group = @group
  #  @group3.save!
  #  @group4 = Group.new
  #  @group4.attributes = valid_group_attributes
  #  @group4.parent_group = @group2
  #  @group4.save!
  #  @group.destroy
  #  @group2 = Group.find(@group2.id) and @group3 = Group.find(@group3.id) and @group4 = Group.find(@group4.id)
  #  @group2.should be_deleted and @group3.should be_deleted and @group4.should be_deleted
  #  @group2.should_not be_authorized_for('show','edit','delete','list')
  #end

  ## authorized_for?('show','edit','delete','list') = true
  #it "non deleted group should be authorized_for \"show\" \"edit\" \"delete\" \"list\"" do
  #  @group.should be_authorized_for('show','edit','delete','list')
  #end

  ## destroy, authorized_for?('show','edit','delete','list') = false
  #it "deleted group should not be authorized_for \"show\" \"edit\" \"delete\" \"list\"" do
  #  @group.attributes = valid_group_attributes
  #  @group.destroy
  #  @group.should_not be_authorized_for('show','edit','delete','list')
  #end

  ## parent_name
  #it "root group should have parent_name = \"\"" do
  #  @group.parent_name.should eql("")
  #end

  ## parent_name
  #it "subgroup should have parent_name = parent_group_name" do
  #  @group2 = Group.new and @group2.attributes = valid_group_attributes and @group2.name = "Subgrupo da Moda"
  #  @group2.parent_group = @group
  #  @group2.parent_name.should eql(@group.name)
  #end

  ## has_many users
  it "should have many users" do
    should have_and_belong_to_many :direct_users
  end

  ## All users
  it "all_users should return all users from group" do
    @user1 = User.new and @user1.attributes = {:email => 'admin@simon.com',
                                               :password => 'simonadmin',
                                               :password_confirmation => 'simonadmin',
                                               :name => 'Admin'}
    @user2 = User.new and @user2.attributes = {:email => 'root@simon.com',
                                               :password => 'simonroot',
                                               :password_confirmation => 'simonroot',
                                               :name => 'Root'}
    @user3 = User.new and @user3.attributes = {:email => 'anonymous@anonym.com',
                                               :password => 'pretypass',
                                               :password_confirmation => 'pretypass',
                                               :name => 'Unnamed'}
    @user1.save! and @user2.save! and @user3.save!
    @group.direct_users <<  [@user1,@user2]
    @group.all_users.should include(@user1,@user2)
    @group.all_users.should_not include(@user1,@user2,@user3)
  end

describe User do
end

end

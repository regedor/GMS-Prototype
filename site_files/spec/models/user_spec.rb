require File.dirname(__FILE__) + '/../spec_helper'

module UserSpecHelper

  def valid_user_attributes
    {
      :email => 'admin@simon.com',
      :password => 'simonadmin',
      :password_confirmation => 'simonadmin',
      :name => 'Admin'
    }
  end

  def valid_password
    {
       :password => 'passwordsecreta',
       :password_confirmation => 'passwordsecreta'
    }
  end

end

describe User do

  include UserSpecHelper

  before do
    @user = User.new
  end

  ## valid?
  it "new user should be valid" do
    @user.attributes = valid_user_attributes
    @user.should be_valid
  end

  ## deleted? = false
  it "new user should not be deleted" do
    @user.attributes = valid_user_attributes
    @user.should_not be_deleted
  end

  ## destroy, deleted? = true
  it "after destroying a user, user should be deleted" do
    @user.attributes = valid_user_attributes
    @user.destroy
    @user.should be_deleted
    @user.should_not be_authorized_for('show','edit','delete','list')
  end

  ## authorized_for?('show','edit','delete','list') = true
  it "non deleted user should be authorized_for \"show\" \"edit\" \"delete\" \"list\"" do
    @user.attributes = valid_user_attributes
    @user.should be_authorized_for('show','edit','delete','list')
  end

  ## destroy, authorized_for?('show','edit','delete','list') = false
  it "deleted user should not be authorized_for \"show\" \"edit\" \"delete\" \"list\"" do
    @user.attributes = valid_user_attributes
    @user.destroy
    @user.should_not be_authorized_for('show','edit','delete','list')
  end

  ## activate!, active? = true
  it "after activating a user, user should be active" do
    @user.attributes = valid_user_attributes
    @user.activate!
    @user.should be_active
  end

  ## deactivate?, active? = false
  it "after deactivating a user, user should not be active" do
    @user.attributes = valid_user_attributes
    @user.deactivate!
    @user.should_not be_active
  end


  ## Not tested yet:
  ## send_invitation(mail)
  ## deliver_activation_instructions!
  ## deliver_activation_confirmation!
  ## deliver_password_reset_instructions!

  ## set_role!(role)
  it "after changing user role, role should change" do
    @user.attributes = valid_user_attributes
    @role = @user.role
    @user.set_role!(:admin)
    @user.role.should_not eql(@role)
  end

  ## is_role?(:admin)
  it "admin user should have admin role" do
    @user.attributes = valid_user_attributes
    @user.set_role!(:admin)
    @user.should be_is_role(:admin)
  end

  ## is_role?(:user)
  it "normal user should have user role" do
    @user.attributes = valid_user_attributes
    @user.set_role!(:user)
    @user.should be_is_role(:user)
    @user.should_not be_is_role(:admin)
  end

  ## role_sym, set_role!(role)
  it "setting role from role_sym should not change role at all" do
    @user.attributes = valid_user_attributes
    @role = @user.role
    @user.set_role!(@user.role_sym)
    @user.role.should eql(@role)
  end

  ## first_name
  it "first_name method should return first name from user's name" do
    @user.attributes = valid_user_attributes
    @user.name = "Zé Carlos"
    @user.first_name.should eql("Zé")
  end

  ## destroy_by_ids(ids)
  it "destroying users by ids, should destroy any user with id in ids" do
    @user1 = User.new and @user2 = User.new and @user3 = User.new
    @user1.email = 'mail1@mail.pt' and @user2.email = 'mail2@mail.pt' and @user3.email = 'mail3@mail.pt'
    @user1.attributes = valid_password and @user2.attributes = valid_password and @user3.attributes = valid_password
    @user1.save! and @user2.save! and @user3.save!
    @user1.should_not be_deleted and @user2.should_not be_deleted and @user3.should_not be_deleted
    User.destroy_by_ids([@user1.id,@user2.id,@user3.id]).should be_true
    @user1 = User.find(@user1.id) and @user2 = User.find(@user1.id) and @user3 = User.find(@user1.id)
    @user1.should be_deleted and @user2.should be_deleted and @user3.should be_deleted
  end

  ## activate!(ids)
  it "activating users by ids, should activate any user with id in ids" do
    @user1 = User.new and @user2 = User.new and @user3 = User.new
    @user1.email = 'mail1@mail.pt' and @user2.email = 'mail2@mail.pt' and @user3.email = 'mail3@mail.pt'
    @user1.attributes = valid_password and @user2.attributes = valid_password and @user3.attributes = valid_password
    @user1.save! and @user2.save! and @user3.save!
    User.activate!([@user1.id,@user2.id,@user3.id]).should be_true
    @user1 = User.find(@user1.id) and @user2 = User.find(@user1.id) and @user3 = User.find(@user1.id)
    @user1.should be_active and @user2.should be_active and @user3.should be_active
  end

  ## deactivate!(ids)
  it "deactivating users by ids, should deactivate any user with id in ids" do
    @user1 = User.new and @user2 = User.new and @user3 = User.new
    @user1.email = 'mail1@mail.pt' and @user2.email = 'mail2@mail.pt' and @user3.email = 'mail3@mail.pt'
    @user1.attributes = valid_password and @user2.attributes = valid_password and @user3.attributes = valid_password
    @user1.save! and @user2.save! and @user3.save!
    User.deactivate!([@user1.id,@user2.id,@user3.id]).should be_true
    @user1 = User.find(@user1.id) and @user2 = User.find(@user1.id) and @user3 = User.find(@user1.id)
    @user1.should_not be_active and @user2.should_not be_active and @user3.should_not be_active
  end

end

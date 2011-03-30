require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  before(:each) do
    DatabaseCleaner.start
  end

  after(:each) do
    DatabaseCleaner.clean
  end
  

  # ==========================================================================
  # Relationships
  # ==========================================================================

  it { should have_and_belong_to_many(:groups) }

  it { should belong_to(:role) }


  # ==========================================================================
  # Validations
  # ==========================================================================
  
  it { should validate_presence_of(:language) }

  it { should validate_presence_of(:email) }

  it "should only accept unique email" do
    Factory.create(:valid_user)
    Factory.build(:valid_user).should validate_uniqueness_of( :email )
  end
  

  ["(123) 456-7890", "964412321", "+44 7789860152" ].each do |value|
    it { should allow_value(value).for(:phone) }
  end

  %w(abcd 1234).each do |value|
    it { should_not allow_value(value).for(:phone) }
  end


  # ==========================================================================
  # Attributes Accessors
  # ==========================================================================
  
  [:crypted_password, :role, :active].each do |attribute|
    it { should_not allow_mass_assignment_of(attribute) }
  end

   [:email                  ,                   
    :name                   ,                   
    :password               ,            
    :password_confirmation  ,  
    :nickname               ,                      
    :gender                 ,                      
    :profile                ,                      
    :website                ,                      
    :country                ,                      
    :phone                  ,                      
    :emails                 ,        
    :language               , 
    :openid_identifier      ,                   
    :groups                 ,                               
    :row_mark               ].each do |attribute|        
      it { should allow_mass_assignment_of(attribute) }
    end


  # ==========================================================================
  # Extra definitions and Class Methods
  # ==========================================================================

  it { Factory.build(:valid_user).should be_historicable }

  it "should not be findable after destroy" do
    user = Factory.create(:valid_user)
    user_email = user.email
    user.destroy
    User.find_by_email(user_email).should be(nil)
  end

  it "should be findable as DeletedUser after destroy" do
    user = Factory.create(:valid_user)
    user_email = user.email
    user.destroy
    DeletedUser.find_by_email(user_email).should_not be(nil) 
  end

  it "should not be findable as DeletedUser before destroy" do
    user = Factory.create(:valid_user)
    DeletedUser.find_by_email(user.email).should be(nil)
  end

  # ==========================================================================
  # Active Scaffold stuff
  # ==========================================================================

  it "should be able to create if it is admin" do
    user         = Factory.build(:admin_user)
    current_user = Factory.build(:admin_user)
    user.should_receive(:current_user).and_return(current_user)
    user.authorized_for_create?.should be(true)
  end
  
#  it "should not be able to create if it is not admin" do
#    user = Factory.build(:normal_user)
#    Authorization::Engine.instance.permit?( :as_create, :context => :admin_users).should be(false)
#  end

#  it "should be able to read if it is admin" do
#    user = Factory.create(:admin_user)
#    Authorization::Engine.instance.permit?( :as_read, :context => :admin_users).should be(true)
#  end

#  it "should not be able to read if it is not admin" do
#    user = Factory.create(:normal_user)
#    Authorization::Engine.instance.permit?( :as_read, :context => :admin_users).should be(false)
#  end
  
#  it "should be able to update if it is admin" do
#    user = Factory.create(:admin_user)
#    Authorization::Engine.instance.permit?( :as_update, :context => :admin_users).should be(true)
#  enduser = Factory.create(:normal_user)
  
#  it "should not be able to update if it is not admin" do
#    user = Factory.build(:normal_user)
#    Authorization::Engine.instance.permit?( :as_update, :context => :admin_users).should be(false)
#  end
  
#  it "should be able to delete if it is admin" do
#    user = Factory.create(:admin_user)
#    Authorization::Engine.instance.permit?( :as_delete, :context => :admin_users).should be(true)
#  end
  
#  it "should not be able to delete if it is not admin" do
#    user = Factory.build(:normal_user)
#    Authorization::Engine.instance.permit?( :as_delete, :context => :admin_users).should be(false)
#  end

#  it "should be able to update group if it is admin" do
#    user = Factory.create(:admin_user)
#    Authorization::Engine.instance.permit?( :as_update, :context => :admin_groups).should be(true)
#  end
  
#  it "should not be able to update group if it is not admin" do
#    user = Factory.build(:normal_user)
#    Authorization::Engine.instance.permit?( :as_update, :context => :admin_users).should be(false)
#  end
  
#  it "should be able to update role if it is admin" do
#    user = Factory.create(:admin_user)
#    Authorization::Engine.instance.permit?( :manage, :context => :user_roles).should be(true)
#  end
  
#  it "should not be able to update role if it is not admin" do
#    user = Factory.build(:normal_user)
#    Authorization::Engine.instance.permit?( :manage, :context => :user_roles).should be(false)
#  end
  
  
  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  describe '#to_label?' do
    it "should return a label using first and last name" do
      user = Factory.build :valid_user, :name => "Miguel da Torre", :email => "miguel@regedor.com"
      user.to_label.should eql("Miguel Torre < miguel@regedor.com >")
    end

    it "should return a label when the user has a single name" do
      user = Factory.build :valid_user, :name => "Miguel", :email => "miguel@regedor.com"
      user.to_label.should eql("Miguel < miguel@regedor.com >")
    end

    it "should return a label when user has no name" do
      user = Factory.build :valid_user, :name => "", :email => "miguel@regedor.com"
      user.to_label.should eql("< miguel@regedor.com >")
    end

  end
  
  it "should not create history entry if not changed" do
    user = Factory.create(:valid_user)
    user.create_history_entry?.should be(false)
  end
  
  it "should create history entry if changed" do
    user = Factory.create(:valid_user)
    user.email= "aaa@aaa.com"
    user.create_history_entry?.should be(true)
  end
  
  
  it "should have first_and_last_name method renamed" do
    user = Factory.create(:valid_user)
    user.historicable_name.should eql(user.first_and_last_name)
  end


#  it "should have a role symbol" do
#    user = Factory.create(:valid_user)
#    user.role.label.should eql(user.role_symbol.to_s)
#  end

  it "should be deleted after destroyed" do
    user = Factory.create(:valid_user)
    user.destroy
    user.deleted.should be(true)
  end
  
#?  include Notifier

 
#  it "notification 1" do
#    user = Factory.create(:valid_user)
#    Notifier.deliver_invitation(user,user.email)
#  end

#  it "notification 2" do
#    
#  end

#  it "notification 3" do
#    
#  end

#  it "notification 4" do
#    
#  end

  it "should have first name" do
    user = Factory.create(:valid_user)
    user.first_name.should eql(user.name.split(" ").first)
  end

  it "should have last name" do
    user = Factory.create(:valid_user)
    user.last_name.should eql(user.name.split(" ").last)
  end

  it "should have first and last name" do
    user = Factory.create(:valid_user)
    user.first_and_last_name.should eql([user.first_name,user.last_name].join(" ").chomp " ")
  end
  
  it "should have small name" do
    user = Factory.create(:valid_user)
    user.small_name.should eql(user.nickname || user.first_name)
  end
  
  it "should have nickname or first and last name" do
    user = Factory.create(:valid_user)
    user.nickname_or_first_and_last_name.should eql(user.nickname || user.first_and_last_name)
  end
 
  it "should list the groups as string" do 
    user = Factory.create(:valid_user)
    r = []
    g1 = Factory.create(:group)
    user.groups << g1
    g2 = Factory.create(:group)
    user.groups << g2
    user.groups.each do |f|
      r << f.name
    end
    str = r.join ', '
    user.list_groups.should eql(str)
  end
  
  it "should add role if not present before save" do  
#puts Role.id_for(:user)
#puts Role.find_by_symbol(:user).id

    user = Factory.create(:valid_user)

puts "\n \n --- "+ Role.find_by_id( user.role.id                   ).label
#puts "\n \n --- "+ Role.find_by_id( Role.find_by_symbol(:user).id  ).label

    #user.role_id.should be(Role.id_for(:user))    
    Role.count.should be(6)
  end
  
  # ==========================================================================
  # Instance Methods
  # ==========================================================================  

  it "should destroy by ids" do
    user = Factory.create(:valid_user)
    user2 = Factory.create(:valid_user)
    User.destroy_by_ids!([user.id,user2.id]).should be(true)
  end
  
  it "should activate by ids" do
    user = Factory.create(:valid_user)
    user2 = Factory.create(:valid_user)
    User.activate!([user.id, user2.id]).should be(true)
  end
  
  it "should deactivate by ids" do
    user = Factory.create(:valid_user)
    user2 = Factory.create(:valid_user)
    User.deactivate!([user.id, user2.id]).should be(true)
  end 

#  ## valid?
#  it "new user should be valid" do
#    @user.attributes = valid_user_attributes
#    @user.should be_valid
#  end
#
#  ## deleted? = false
#  it "new user should not be deleted" do
#    @user.attributes = valid_user_attributes
#    @user.should_not be_deleted
#  end
#
#  ## destroy, deleted? = true
#  it "after deleting a user, user should be deleted" do
#    @user.attributes = valid_user_attributes
#    @user.delete!
#    @user.should be_deleted
#  end
#
#  ## authorized_for?('show','edit','delete','list') = true
#  #it "non deleted user should be authorized_for \"show\" \"edit\" \"delete\" \"list\"" do
#  #  @user.attributes = valid_user_attributes
#  #  @user.should be_authorized_for('show','edit','delete','list')
#  #end
#
#  ## destroy, authorized_for?('show','edit','delete','list') = false
#  #it "deleted user should not be authorized_for \"show\" \"edit\" \"delete\" \"list\"" do
#  #  @user.attributes = valid_user_attributes
#  #  @user.destroy
#  #  @user.should_not be_authorized_for('show','edit','delete','list')
#  #end
#
#  ## activate!, active? = true
#  it "after activating a user, user should be active" do
#    @user.attributes = valid_user_attributes
#    @user.activate!
#    @user.should be_active
#  end
#
#  ## deactivate?, active? = false
#  it "after deactivating a user, user should not be active" do
#    @user.attributes = valid_user_attributes
#    @user.deactivate!
#    @user.should_not be_active
#  end
#
#
#  ## Not tested yet:
#  ## send_invitation(mail)
#  ## deliver_activation_instructions!
#  ## deliver_activation_confirmation!
#  ## deliver_password_reset_instructions!
#
#  ## set_role!(role)
#  #it "after changing user role, role should change" do
#  #  @user.attributes = valid_user_attributes
#  #  @role = @user.role
#  #  @user.set_role!(:admin)
#  #  @user.role.should_not eql(@role)
#  #end
#
#  ## is_role?(:admin)
#  #it "admin user should have admin role" do
#  #  @user.attributes = valid_user_attributes
#  #  @user.set_role!(:admin)
#  #  @user.should be_is_role(:admin)
#  #end
#
#  ## is_role?(:user)
#  #it "normal user should have user role" do
#  #  @user.attributes = valid_user_attributes
#  #  @user.set_role!(:user)
#  #  @user.should be_is_role(:user)
#  #  @user.should_not be_is_role(:admin)
#  #end
#
#  ## role_sym, set_role!(role)
#  #it "setting role from role_sym should not change role at all" do
#  #  @user.attributes = valid_user_attributes
#  #  @role = @user.role
#  #  @user.set_role!(@user.role_sym)
#  #  @user.role.should eql(@role)
#  #end
#
#  ## first_name
#  it "first_name method should return first name from user's name" do
#    @user.attributes = valid_user_attributes
#    @user.name = "Zé Carlos"
#    @user.first_name.should eql("Zé")
#  end
#
#  ## delete_by_ids(ids)
#  it "deleting users by ids, should delete any user with id in ids" do
#    @user1 = User.new and @user2 = User.new and @user3 = User.new
#    @user1.attributes = valid_password and @user2.attributes = valid_password and @user3.attributes = valid_password
#    @user1.email = 'mail1@mail.pt' and @user2.email = 'mail2@mail.pt' and @user3.email = 'mail3@mail.pt'
#    @user1.save! and @user2.save! and @user3.save!
#    @user1.should_not be_deleted and @user2.should_not be_deleted and @user3.should_not be_deleted
#    User.delete_by_ids!([@user1.id,@user2.id,@user3.id]).should be_true
#    @user1 = User.find(@user1.id) and @user2 = User.find(@user1.id) and @user3 = User.find(@user1.id)
#    @user1.should be_deleted and @user2.should be_deleted and @user3.should be_deleted
#  end
#
#  ## undelete_by_ids(ids)
#  it "undeleting users by ids, should undelete any user with id in ids" do
#    @user1 = User.new and @user2 = User.new and @user3 = User.new
#    @user1.email = 'mail1@mail.pt' and @user2.email = 'mail2@mail.pt' and @user3.email = 'mail3@mail.pt'
#    @user1.attributes = valid_password and @user2.attributes = valid_password and @user3.attributes = valid_password
#    @user1.delete! and @user2.delete! and @user3.delete!
#    @user1.save! and @user2.save! and @user3.save!
#    @user1.should be_deleted and @user2.should be_deleted and @user3.should be_deleted
#    User.undelete_by_ids!([@user1.id,@user2.id,@user3.id]).should be_true
#    @user1 = User.find(@user1.id) and @user2 = User.find(@user1.id) and @user3 = User.find(@user1.id)
#    @user1.should_not be_deleted and @user2.should_not be_deleted and @user3.should_not be_deleted
#  end
#
#  ## activate!(ids)
#  it "activating users by ids, should activate any user with id in ids" do
#    @user1 = User.new and @user2 = User.new and @user3 = User.new
#    @user1.email = 'mail1@mail.pt' and @user2.email = 'mail2@mail.pt' and @user3.email = 'mail3@mail.pt'
#    @user1.attributes = valid_password and @user2.attributes = valid_password and @user3.attributes = valid_password
#    @user1.save! and @user2.save! and @user3.save!
#    User.activate!([@user1.id,@user2.id,@user3.id]).should be_true
#    @user1 = User.find(@user1.id) and @user2 = User.find(@user1.id) and @user3 = User.find(@user1.id)
#    @user1.should be_active and @user2.should be_active and @user3.should be_active
#  end
#
#  ## deactivate!(ids)
#  it "deactivating users by ids, should deactivate any user with id in ids" do
#    @user1 = User.new and @user2 = User.new and @user3 = User.new
#    @user1.email = 'mail1@mail.pt' and @user2.email = 'mail2@mail.pt' and @user3.email = 'mail3@mail.pt'
#    @user1.attributes = valid_password and @user2.attributes = valid_password and @user3.attributes = valid_password
#    @user1.save! and @user2.save! and @user3.save!
#    User.deactivate!([@user1.id,@user2.id,@user3.id]).should be_true
#    @user1 = User.find(@user1.id) and @user2 = User.find(@user1.id) and @user3 = User.find(@user1.id)
#    @user1.should_not be_active and @user2.should_not be_active and @user3.should_not be_active
#  end
#
end

class Api::CreateGroupsController < ApplicationController
  
  def create_group
    new_group = Group.create :name => params[:name]
    params[:selected].each do |id|
      new_group.direct_users << User.find(id)
    end  
    
    respond_to do |format|
      format.js {
        flash[:notice] = "Created Group (not i18n)"
        render :text => "", :layout => false  
      }
    end   
  end  
  
end  
class GroupController < ApplicationController
  
  def index
    @groups = Group.find(:all)
  end
  
  def new
    @group = Group.new
  end  
  
  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:notice] = 'Group successfuly created'
      redirect_to @group
    else
      render :action => 'new'
    end    
  end  
  
  def show
    @group = Group.find(params[:id])
  end  
  
end

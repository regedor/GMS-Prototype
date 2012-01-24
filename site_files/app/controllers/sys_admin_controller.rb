class SysAdminController < ApplicationController

  def log
    log = %x[tail -n 200 log/production.log].gsub("\n",'<br />')
    render :text => log
  end
  
  def update_current_user
    if configatron.debug_bar == "true" && User.find(parmas[:user][:id]).update_attributes(parmas[:user])
    user = current_user
    user.role_id = params[:user][:role_id]
    if user.save
      flash[:notice] = "Done"
    else
      flash[:error] = "error" 
    end
    redirect_to admin_root_path
  end

end
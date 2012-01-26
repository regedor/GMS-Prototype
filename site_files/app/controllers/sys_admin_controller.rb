class SysAdminController < ApplicationController

  def log
    log = %x[tail -n 200 log/production.log].gsub("\n",'<br />')
    render :text => log
  end
  
  def update_current_user
    user = current_user
    user.role_id = params[:user][:role_id]
    configatron.debug_bar && user.save ? flash[:notice] = "Done" : flash[:error] = "Error happened" 
    redirect_to admin_root_path
  end

end
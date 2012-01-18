class SysAdminController < ApplicationController

  def log
    log = %x[tail -n 200 log/production.log].gsub("\n",'<br />')
    render :text => log
  end

end
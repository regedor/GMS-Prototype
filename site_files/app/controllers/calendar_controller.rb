class CalendarController < ApplicationController
  
  def index
    respond_to do |format|
      format.js { 
        render :partial => 'events/calendar',
               :layout => false,
               :locals => {
                 :month => params[:month].to_i,
                 :year  => params[:year].to_i
               }
      }
    end
  end   

end  
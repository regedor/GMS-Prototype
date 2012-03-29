class CalendarController < ApplicationController
  def index
    render :partial => 'events/calendar',
      :layout => false,
      :locals => {
        :cal_month => params[:cal_month].to_i,
        :cal_year  => params[:cal_year].to_i
      }
  end   
end  
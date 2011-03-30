class EventActivitiesController < ApplicationController


  def show
    @record = EventActivity.find(params[:id])
  end

end

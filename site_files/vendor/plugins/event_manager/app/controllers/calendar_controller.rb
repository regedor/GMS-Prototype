class CalendarController < ApplicationController

  def index
    @cal_month = (params[:cal_month] || Time.zone.now.month).to_i
    @cal_year = (params[:cal_year] || Time.zone.now.year).to_i

    @shown_month = Date.civil(@cal_year, @cal_month)

    @event_strips = Event.event_strips_for_month(@shown_month)

    # To restrict what events are included in the result you can pass additional find options like this:
    #
    # @event_strips = Event.event_strips_for_month(@shown_month, :include => :some_relation, :conditions => 'some_relations.some_column = true')
    #

  end

end

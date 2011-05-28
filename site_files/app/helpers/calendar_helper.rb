module CalendarHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end

  # custom options for this calendar
  def event_calendar_options(year, month, event_strips, shown_month)
    {
      :year => year,
      :month => month,
      :event_strips => event_strips,
      :month_name_text => I18n.localize(shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(shown_month.prev_month),
      :next_month_text => month_link(shown_month.next_month) + " >>",
      :width => nil,
      :heigth => 400,
      
      :day_names_height => 18,
      :day_nums_height => 18,
      :event_height => 15,
      :event_margin => 1,
      :event_padding_top => 1,
      
      :use_all_day => true,
      :use_javascript => true,
      :link_to_day_action => false
    }
  end

  def event_calendar(year, month, event_strips, shown_month)
    calendar event_calendar_options(year, month, event_strips, shown_month) do |args|
      event = args[:event]
      html = %(<span class="title">#{h(event.name)}</span>)
      
    end
  end
  
end

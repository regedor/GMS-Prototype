module CalendarHelper
  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), { :month => month_date.month, :year => month_date.year })
  end

  def prev_month_link(month_date)
    link_to("◄", { :month => month_date.month, :year => month_date.year })
  end

  def next_month_link(month_date)
    link_to("►", { :month => month_date.month, :year => month_date.year })
  end

  # custom options for this calendar
  def event_calendar_options(year, month, event_strips, shown_month)
    {
      :year => year,
      :month => month,
      :event_strips => event_strips,
      :month_name_text => I18n.localize(shown_month, :format => "%B %Y"),
      :previous_month_text => prev_month_link(shown_month.prev_month),
      :next_month_text => next_month_link(shown_month.next_month)
    }
  end

  def event_calendar(year, month, event_strips, shown_month)
    calendar event_calendar_options(year, month, event_strips, shown_month) do |args|
      event = args[:event]
      html = %(<span class="title">#{h(event.name)}</span>)
      
    end
  end
  
end

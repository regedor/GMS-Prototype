module WidgetHelper

  def recipes_of_the_day_widget
    render 'widgets/recipes_of_the_day'
  end

  # Lisbon and Paris clocks (must load CSS and JS in head)
  def clocks_widget
    render 'widgets/clocks'
  end

  def weather_condition_image(condition)
    image = "na.png"

    case condition.to_i
    when 0 # tornado
      image = "wind.png"
    when 1 # tropical storm
      image = "rain_day.png"
    when 2 # hurricane
      image = "wind.png"
    when 3 # severe thunderstorms
      image = "thunders.png"
    when 4 # thunderstorms
      image = "thunders.png"
    when 5 # mixed rain and snow
      image = "snow_and_rain.png"
    when 6 # mixed rain and sleet
      image = "snow_and_rain.png"
    when 7 # mixed snow and sleet
      image = "snow_and_rain.png"
    when 8 # freezing drizzle
      image = "snow_and_rain.png"
    when 9 # drizzle
      image = "rain.png"
    when 10 # freezing rain
      image = "ice_freeze.png"
    when 11 # showers
      image = "rain.png"
    when 12 # showers
      image = "rain.png"
    when 13 #snow flurries
      image = "snow.png"
    when 14 # light snow showers
      image = "snowing.png"
    when 15 # blowing snow
      image = "snowing.png"
    when 16 # snow
      image = "snow.png"
    when 17 # hail
      image = "hail.png"
    when 18 # sleet
      image = "snow_and_rain.png"
    when 19 # dust
      image = "haze.png"
    when 20 # foggy
      image = "mist.png"
    when 21 # haze
      image = "haze.png"
    when 22 # smoky
      image = "mist.png"
    when 23 # blustery ??
      image = "mist.png"
    when 24 # windy
      image = "wind.png"
    when 25 # cold
      image = "ice_freeze.png"
    when 26 # cloundy
      image = "clouds.png"
    when 27 # mostly cloudy (night)
      image = "cloudy_night.png"
    when 28 # mostly cloudy (day)
      image = "cloudy_day.png"
    when 29 # partly cloudy (night)
      image = "mostly_clear_night.png"
    when 30 # partly cloudy (day)
      image = "mostly_clear.png"
    when 31 # clear (night)
      image = "clear.png"
    when 32 # sunny
      image = "sunny.png"
    when 33 # fair (night)
      image = "clear.png"
    when 34 # fair (day)
      image = "sunny.png"
    when 35 # mixed rain and hail
      image = "showers.png"
    when 36 # hot
      image = "sunny.png"
    when 37 # isolated thunderstorms
      image = "thunders.png"
    when 38 # scattered thunderstorms
      image = "thunders.png"
    when 39 # scattered thunderstorms
      image = "thunders.png"
    when 40 # scattered showers
      image = "showers.png"
    when 41 # heavy snow
      image = "snowing.png"
    when 42 # scattered snow showers
      image = "snow_and_rain.png"
    when 43 # heavy snow
      image = "snowing.png"
    when 44 # partly cloudy
      image = "cloudy_day.png"
    when 45 # thundershowers
      image = "thunders.png"
    when 46 # snow showers
      image = "snow_and_rain.png"
    when 47 # isolated thundershowers
      image = "thunders.png"
    end

    "<img src=\"/images/widgets/weather/#{image}\" height=\"60px\" width=\"85px\">"
  end

  # Show tags as a 2 level menu of limit elements (can be acompanied by the tag_header)
  def tag_menu_widget(tags, limit=10, just_items=false)
    tags_for_cloud = YAML::load(Rails.cache.fetch("tags_for_cloud"){Tag.tags_for_menu(tags, limit).to_yaml})
    render :partial => 'widgets/tag_menu',
    :locals  => {
      :tags_for_cloud => tags_for_cloud,
      :tags => tags,
      :just_items => just_items
    }
  end

  # Show tags as a cloud (should be acompanied by the tag_header)
  def tag_cloud_widget(tags)
    tags_for_cloud = Rails.cache.fetch "tags_for_cloud" do
      Tag.tags_for_cloud(tags)
    end
    render :partial => 'widgets/tag_cloud',
      :locals  => { :tags_for_cloud => tags_for_cloud, :tags => tags }
  end

  # List of tags being used takes optional parameter to set cloud or menu
  def tag_header(tags, cloud=true)
    if tags
      tags = tags[0..1] unless cloud
      render :partial => 'widgets/tag_cloud_header',
        :locals  => { :tags => tags }
    end
  end
end

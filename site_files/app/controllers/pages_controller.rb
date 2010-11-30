class PagesController < ApplicationController
  filter_access_to :all
  
  def root_page
    render :action => logged_in? ? 'home' : 'about'
  end

  def about
  end

  def home
  end
end

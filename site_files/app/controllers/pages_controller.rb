class PagesController < ApplicationController
  before_filter :require_user, :only => :home
  
  def root_page
    render :action => logged_in? ? 'home' : 'about'
  end

  def about
  end

  def home
  end
end

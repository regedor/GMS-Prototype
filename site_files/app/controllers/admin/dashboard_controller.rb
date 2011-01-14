class Admin::DashboardController < Admin::BaseController
  filter_access_to :index, :require => :read
  helper :sparklines
  def index
    @graphArray = Array.new()
    200.times do 
      @graphArray << rand(200)
    end
  end
end

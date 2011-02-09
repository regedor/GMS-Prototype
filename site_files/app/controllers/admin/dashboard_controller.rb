class Admin::DashboardController < Admin::BaseController
  filter_access_to :index, :require => :read
end

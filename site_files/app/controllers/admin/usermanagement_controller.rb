class Admin::UsermanagementController < ApplicationController
	layout 'admin'

	def index
		@page = params[:id]
  end

end

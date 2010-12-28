class Api::I18nsController < ApplicationController
  def show
    render :text => t(params[:path], params[:pairs])
  end
end


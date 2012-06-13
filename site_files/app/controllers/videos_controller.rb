class VideosController < ApplicationController
  
  def index
    @page = params[:page] ? params[:page].to_i : 1
    @videos = yt_client.my_videos(:per_page => 3, :page => @page)
  end
  
end

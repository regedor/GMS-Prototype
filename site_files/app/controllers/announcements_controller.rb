class AnnouncementsController < ApplicationController
  def show
    @announcement = Announcement.find params[:id]
  end
end


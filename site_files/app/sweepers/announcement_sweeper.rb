class AnnouncementSweeper < ActionController::Caching::Sweeper
  observe Announcement
 
  def after_create(announcement)
    expire_cache_for(announcement)
  end
 
  def after_update(announcement)
    expire_cache_for(announcement)
  end
 
  def after_destroy(announcement)
    expire_cache_for(announcement)
  end
 
  private
  def expire_cache_for(announcement)
    expire_fragment("announcement/#{announcement.id}")
  end
end
class GlobalCategorySweeper < ActionController::Caching::Sweeper
  observe GlobalCategory
 
  def after_create(category)
    expire_cache_for(category)
  end
 
  def after_update(category)
    expire_cache_for(category)
  end
 
  def after_destroy(category)
    expire_cache_for(category)
  end
 
  private
  def expire_cache_for(category)
    expire_fragment("news_grid_block/#{category.id}")
  end
  
end
class PostSweeper < ActionController::Caching::Sweeper
  observe Post
 
  def after_create(post)
    expire_cache_for(post)
  end
 
  def after_update(post)
    expire_cache_for(post)
  end
 
  def after_destroy(post)
    expire_cache_for(post)
  end
 
  private
  def expire_cache_for(post)
    expire_fragment("post/#{post.id}")
    expire_fragment("news_grid_block/#{post.global_category.id}")
  end
end
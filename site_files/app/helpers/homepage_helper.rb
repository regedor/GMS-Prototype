module HomepageHelper
  
  # Renders a two column news grid (currently used for paris portugues)
  def category_news_grid
    render :partial => 'shared/homepage/category_news_grid'
  end
  
end
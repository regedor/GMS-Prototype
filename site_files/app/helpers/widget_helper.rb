module WidgetHelper
  
  # Lisbon and Paris clocks (must load CSS and JS in head)
  def clocks_widget
    render :partial => 'widgets/clocks'
  end
  
  # Show tags as a 2 level menu of limit elements
  def tag_menu_widget(tags,limit=3)
    tags_for_cloud = Tag.tags_for_menu(tags,limit) 
    render :partial => 'widgets/tag_menu', 
           :locals => {:tags_for_cloud => tags_for_cloud, :tags => tags}
  end
  
  # Show tags as a cloud (should be acompanied by the tag_cloud_header)
  def tag_cloud_widget(tags)
    tags_for_cloud = Tag.tags_for_cloud(tags)
    render :partial => 'widgets/tag_cloud', 
           :locals => {:tags_for_cloud => tags_for_cloud, :tags => tags}
  end
  
  def tag_cloud_header(tags)
    render :partial => 'widgets/tag_cloud_header', 
           :locals => {:tags => tags} if tags
  end
end
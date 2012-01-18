module WidgetHelper
  
  # Lisbon and Paris clocks (must load CSS and JS in head)
  def clocks_widget
    render :partial => 'widgets/clocks'
  end
  
  # Show tags as a 2 level menu of limit elements (can be acompanied by the tag_header)
  def tag_menu_widget(tags, limit = 10)
    tags_for_cloud = Tag.tags_for_menu(tags, limit) 
    render :partial => 'widgets/tag_menu', 
           :locals  => { :tags_for_cloud => tags_for_cloud, :tags => tags }
  end
  
  # Show tags as a cloud (should be acompanied by the tag_header)
  def tag_cloud_widget(tags)
    tags_for_cloud = Tag.tags_for_cloud(tags)
    render :partial => 'widgets/tag_cloud', 
           :locals  => { :tags_for_cloud => tags_for_cloud, :tags => tags }
  end
  
  # List of tags being used takes optional parameter to set cloud or menu
  def tag_header(tags, cloud = true)
    if tags
      tags = tags[0..1] unless cloud
      render :partial => 'widgets/tag_cloud_header',
             :locals  => { :tags => tags }
    end
  end
end
module NavigationHelper
  
  def frontend_navigation_content 
    html = ""
    html += tag("ul",nil,true)
    html+= configatron.frontend_navigation.gsub(/__SelectedPages__/) do |match|
      pages=""
      Page.navigation_pages.viewable_only(current_user).each do |page|
        pages += tag("li",nil,true)+link_to(page.title, page_path(page))+tag("/li",nil,true) 
      end
      if configatron.has_gallery == 'true'
        pages +=  tag("li",nil,true)+link_to(t('gallery.title'), albums_path)+tag("/li",nil,true)
      end
      pages
    end
    html += tag("/ul",nil,true)
  end  
  
end  

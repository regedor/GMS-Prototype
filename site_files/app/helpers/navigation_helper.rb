module NavigationHelper
  
  def frontend_navigation_content 
    return configatron.frontend_navigation.gsub(/__SelectedPages__/) { |match|
      html = ""
      html += tag("ul",nil,true)
      Page.navigation_pages.each do |page|
        html += tag("li",nil,true)+link_to(page.title, page_path(page))+tag("/li",nil,true) 
      end  
      html += tag("/ul",nil,true)
    }
  end  
  
end  
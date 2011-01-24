module NavigationHelper
  
  def frontend_navigation_content 
    html = ""
    html += tag("ul",nil,true)
    html+= configatron.frontend_navigation.gsub(/__SelectedPages__/) { |match|
      pages=""
      Page.navigation_pages.each do |page|
        pages += tag("li",nil,true)+link_to(page.title, page_path(page))+tag("/li",nil,true) 
      end  
      pages
    }
    html += tag("/ul",nil,true)
  end  
  
end  
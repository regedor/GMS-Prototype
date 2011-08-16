module Api::CreateGroupsHelper
  
  def the_markup
    html = select("group", "select_all", Group.all.collect {|group| [ group.name, group.id ] }, {:include_blank => true})
    
    html
  end  
  
end  
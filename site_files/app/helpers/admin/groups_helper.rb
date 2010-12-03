module Admin::GroupsHelper

  #Method to generate tree as lists
  def generate_tree(group=Group.subgroups_names_tree) 
    out = group[0] || "<h4>"+I18n.t("admin.groups.index.sidebar.hierarchy.subname")+"</h4>"
    if group.size > 2
      out += "<ul class=\"inner\">"
      group[1..-1].each do |subgroup|
        out += "<li>" + generate_tree(subgroup) + "</li>"
      end
      out += "</ul>"
    end
 
    return out
  end
  
  #--
  #FIXME:moved from model, delete on model
  def groups_names
    users = {}
    users_groups.each do |k,v|
      v.each do |group|
        if users[k]
          users[k] += ", #{group.name}"
        else
          users[k]  = users_hash[k].name + " (" + group.name  
        end
      end
    end
    
    users
  end


end

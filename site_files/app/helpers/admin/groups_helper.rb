module Admin::GroupsHelper

  #Method to generate tree as lists
  def generate_tree(group) 
    out = group[0] || ""
    if group.size > 1
      out += "<ul class=\"inner\">"
      group[1..-1].each do |subgroup|
        out += "<li>" + generate_tree(subgroup) + "</li>"
      end
      out += "</ul>"
    end
 
    return out
  end
  
  #
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

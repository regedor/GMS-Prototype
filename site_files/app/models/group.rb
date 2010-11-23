class Group < ActiveRecord::Base
  belongs_to :parent_group,    :class_name=>"Group", :foreign_key=>"parent_group_id"
  has_many   :subgroups,      :class_name=>"Group", :foreign_key=>"parent_group_id"
  has_and_belongs_to_many :users
  
  
  
  def parent_name
    if self.parent_group.nil?
      return ""
    else
      return self.parent_group.name
    end    
  end
  
  
  #on = self.instance_method(:users)
  #define_method(:this_group_only_users) do
  #  on.bind(self).call
  #end
  #
  #def users
  #  us = self.subgroups.map do |g| g.users end
  #  us.flatten! if us
  #  us.uniq! if us
  #  this_group_only_users << us
  #end  
  
  
  def all_users
    us = self.subgroups.map do |g| g.users end
    us.flatten! if us
    us.uniq! if us
    self.users + us
  end
  

  def all_users_names
    users_groups = {}
    users_hash   = {}
    self.subgroups.each do |subgroup|
      users = (subgroup.users - self.users).flatten.uniq
      users.map { |u| users_groups[u.id] ? users_groups[u.id] << subgroup : users_groups[u.id] = [subgroup] } unless users.empty?
      users.map { |u| users_hash[u.id] ||= u } unless users.empty? 
    end
    
    #FIXME: To move to Helper
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
    
   subgroups_users  = users.values.join "), "
   subgroups_users += ")" unless subgroups_users.nil? || subgroups_users.blank?
   
   group_users = ((self.users.map &:name).join ", ")  
   group_users += ", " unless group_users.nil? || group_users.blank? || subgroups_users.nil? || subgroups_users.blank?
   return group_users + subgroups_users
  end
  
  #Check if is not subgroup of itself
  # not correct
  def subgroup? id
    r = false;
    sg = self.subgroups
    self.subgroup_ids.each do |i|
      print ">", i,id,"<\n"
      if id ==  i
        puts "TRUE !!!"
        r = true
        return true
      else
        tg = Group.find_by_id i
        r = tg.subgroup? id
      end
    end
    return r
  end
  
end

module Api::CreateGroupsHelper
  
  def the_markup
    html = render "api/create_groups"
    users = User.all.collect do |user| 
      {:image => image_tag(avatar_url(user,:size => :small)), :name => user.name, :id => user.id}
    end  
    javascript_tag "var HTML=#{html.to_json};var USERS=#{users.to_json}"
  end  
  
end  
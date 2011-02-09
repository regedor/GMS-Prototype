module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'

    when /admin dashboard/
      '/admin'

    when /admin users list/
      '/admin/users'

    when /admin posts list/
      '/admin/posts'

    when /admin static pages list/
      '/admin/pages'

    when /admin announcements list/
      '/admin/announcements'

    when /^(.*)'s profile page$/i
      '/' #FIXME user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)

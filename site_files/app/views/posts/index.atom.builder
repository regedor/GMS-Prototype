atom_feed(
  :url         => posts_path(:tag => @tags, :format => 'atom', :only_path => false),
  :root_url    => posts_path(:tag => @tags, :only_path => false),
  :schema_date => '2008'
) do |feed|
  feed.title     posts_title(@tags)
  feed.updated   @posts.empty? ? Time.now.utc : @posts.collect(&:edited_at).max
  feed.generator configatron.site_name, "uri" => configatron.site_url

  #feed.author do |xml|
  #  xml.name  configatron.site_name
  #  xml.email configatron.support_email
  #end

  @posts.each do |post|
   feed.entry(post, :url => post_path(post, :only_path => false), :published => post.published_at, :updated => post.edited_at) do |entry|
      entry.title   post.title
      entry.content post.body_html, :type => 'html'
    end
  end
end

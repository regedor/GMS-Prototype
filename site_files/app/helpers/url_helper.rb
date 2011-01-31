module UrlHelper
  def posts_path(options = {})
    tags = options[:tags] ? get_tag_names_from_uncertain_array(options.delete(:tags)) : []
    if this_tag = options.delete(:this_tag)
      tags = add_or_remove_tag(tags, this_tag)
    end
    if tags.length > 0
      options[:tags] = tags.join(",")
      posts_with_tags_path(options)
    else
      super
    end
  end

  def admin_posts_path(options = {})
    tag_ids = options[:tag_ids] ? get_tag_ids_from_uncertain_array(options.delete(:tag_ids)) : []
    if this_tag_id = options.delete(:this_tag_id)
      tag_ids = add_or_remove_tag(tag_ids, this_tag_id)
    end
    if tag_ids.length > 0
      options[:tag_ids] = tag_ids.join(",")
      admin_posts_with_tags_path(options)
    else
      super
    end
  end

  def post_path(post, options = {})
    suffix = options[:anchor] ? "##{options[:anchor]}" : ""
    path = post.published_at.strftime("/%Y/%m/%d/") + post.slug + suffix
    path = URI.join(configatron.site_url, path) if options[:only_path] == false
    path.untaint
  end

  def post_comments_path(post)
    post_path(post) + "/comments"
  end

  def page_path(page)
    if page.is_a? Page
      "/pages/#{page.slug}"
    else
      "/pages/#{page}"
    end
  end

  def page_comments_path(post)
    page_path(post) + "/comments"
  end

  def posts_atom_path(tag)
    if tag.blank?
      formatted_posts_path(:format => 'atom')
    else
      formatted_posts_with_tags_path(:tags => tag, :format => 'atom')
    end
  end
end

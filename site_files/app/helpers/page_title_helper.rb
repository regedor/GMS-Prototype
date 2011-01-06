module PageTitleHelper
  def posts_title(tags)
    if tags
      tag_list = (tags.is_a? Array) ? tags : [tags]
      tag_list = tag_list.join(", ")
    else
      tag_list = ""
    end
    compose_title(tag_list.titleize)
  end

  def post_title(post)
    compose_title(post.title)
  end

  def archives_title
    compose_title("Archives")
  end

  def page_title(page)
    compose_title(page.title)
  end

  private

  def compose_title(*parts)
    (parts << configatron.title).reject(&:blank?).join(" - ")
  end
end

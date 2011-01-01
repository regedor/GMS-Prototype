module TagHelper

  def linked_tag_list(tags)
    tags.collect {|tag| link_to(h(tag.name), posts_path(:tag => tag))}.join(", ")
  end

  # Generates the GET variables for the tag filtered post list.
  # If the new tag belongs to the old array, the tag is removed.
  def url_tag_list_array(old_tag_array, new_tag)

    remove = false
    new_tag = new_tag.to_s
    code = "?"

    old_tag_array.each do |tag|
      if tag == new_tag
        remove = true
        next
      end
      code += "tag_ids[]=#{tag}&"
    end

    if remove
      code = code.chomp('?')
      code = code.chomp('&')
    else
      code += "tag_ids[]=#{new_tag}"
    end

    code
  end

end

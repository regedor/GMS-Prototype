module TagHelper

  def linked_tag_list(tag)
    tag.collect {|tag| link_to(h(tag.name), posts_path(:tags => tag))}.join(", ")
  end

  # If the new tag belongs to the old array, the tag is removed.
  # Duplicates array
  def add_or_remove_tag(old_array, new_tag)
    new_array = old_array.dup
    new_array << new_tag unless new_array.delete new_tag
    return new_array.sort!
  end

  # Duplicates array
  def get_tag_ids_from_uncertain_array(tags)
    tags = [tags] unless tags.is_a? Array
    tags.map do |tag|
      tag = tag.id if tag.is_a? Tag
      tag = tag.to_i if tag.is_a? String
    end
  end

  # Duplicates array
  def get_tag_names_from_uncertain_array(tags)
    tags = [tags] unless tags.is_a? Array
    tags.map { |tag| tag = tag.name if tag.is_a? Tag }
  end

end

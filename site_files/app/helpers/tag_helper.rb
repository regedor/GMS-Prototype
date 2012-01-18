module TagHelper

  def linked_tag_list(tag)
    tag.collect {|tag| link_to(h(tag.name), posts_path(:tags => tag))}.join(", ")
  end

  # If the new tag belongs to the old array, the tag is removed.
  # Duplicates array
  def add_or_remove_tag(old_array, new_tag,sort=true)
    new_array = old_array.dup
    new_array << new_tag unless new_array.delete new_tag
    return sort ? new_array.sort! : new_array
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
    return tags
  end

  def tag_cloud(tags, classes)
    max, min = 0, 0
    tags.each do |tag|
      max = tag.taggings_count.to_i if tag.taggings_count.to_i > max
      min = tag.taggings_count.to_i if tag.taggings_count.to_i < min
    end

    divisor = ((max - min) / classes.size) + 1

    tags.each { |tag|
      yield tag.name, classes[(tag.taggings_count.to_i - min) / divisor]
    }
  end

end

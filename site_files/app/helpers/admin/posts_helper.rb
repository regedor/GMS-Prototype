module Admin::PostsHelper

  # Generates a string from a tags array.
  # All tags are separated by commas.
  def linked_tag_list(tags)
    code = ""
    tags.each { |tag| code = code + '<a href="#">' + tag.name + '</a>, ' }
    return code.chomp(", ")
  end

end

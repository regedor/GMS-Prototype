module Admin::PostsHelper

  #TODO: add the tags path
  def linked_tag_list(tags)
    code = ""
    tags.each { |tag| code = code + '<a href="#">' + tag.name + '</a>, ' }
    return code.chomp(", ")
  end

end

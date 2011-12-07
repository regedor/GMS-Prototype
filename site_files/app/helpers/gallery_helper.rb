module GalleryHelper
  
  def random_image_from_galleries(size="100x50")
    random_image = Image.all.reject{|image| not image.album_id}.sort_by{rand}.first
    return image_tag(random_image.multi_purpose_image.url, :size => size)
  end
  
end
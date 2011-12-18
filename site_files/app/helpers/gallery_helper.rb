module GalleryHelper
  
  def random_image_from_galleries(size="100x50")
    random_image = Image.random
    return image_tag(random_image.multi_purpose_image.url, :size => size)
  end
  
end
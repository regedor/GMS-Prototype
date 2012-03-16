class Image < ActiveRecord::Base
  
  include ActionController::UrlWriter
  #attr_accessible :multi_purpose_image
  
  belongs_to :album
  belongs_to :recipe
  
  has_attached_file :multi_purpose_image, 
                    :styles => { :small => "150x100!", :thumb => "80x50!" },
                    :default_url => '/system/:attachment/:style/missing.png'
  
  validates_attachment_presence :multi_purpose_image
  validates_attachment_size :multi_purpose_image, :less_than => 5.megabytes
  
  def templatify
    {
      :url => self.multi_purpose_image.url.to_s,
      :thumbnail_url => self.multi_purpose_image.url(:thumb).to_s,
      :name => self.multi_purpose_image.instance.attributes["multi_purpose_image_file_name"],
      :delete_url => admin_image_path(self),
      :delete_type => "DELETE"
    }
  end
  
  class << self
    
    def clean_lost_images
      Image.all.select{|image| not image.album_id}.map(&:destroy)
    end
    
  end
end  
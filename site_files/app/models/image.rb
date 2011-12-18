class Image < ActiveRecord::Base
  
  #attr_accessible :multi_purpose_image
  
  belongs_to :album
  
  has_attached_file :multi_purpose_image, 
                    :styles => { :small => "192x142!", :thumb => "80x50!" },
                    :default_url => '/system/:attachment/:style/missing.png'
  
  validates_attachment_presence :multi_purpose_image
  validates_attachment_size :multi_purpose_image, :less_than => 5.megabytes
  
  class << self
    
    def clean_lost_images
      Image.all.select{|image| not image.album_id}.map(&:destroy)
    end
    
  end
end  
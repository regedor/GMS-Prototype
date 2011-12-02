class Album < ActiveRecord::Base
  #attr_accessible :name, :images
  has_many :images, :dependent => :destroy
  
  validates_uniqueness_of :name
  validates_presence_of :name

  accepts_nested_attributes_for :images, :allow_destroy => true#, :reject_if => lambda { |t| t['image'].nil? }

  def cover
    return "56883622_18f242e114_b.jpg" if self.images.empty?
    self.images.first.path
  end  
  
end  
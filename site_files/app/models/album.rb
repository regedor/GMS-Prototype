class Album < ActiveRecord::Base
  attr_accessible :name
  has_many :images
  
  validates_uniqueness_of :name
  validates_presence_of :name

  def cover
    return "56883622_18f242e114_b.jpg" if self.images.empty?
    self.images.first.path
  end  
  
end  
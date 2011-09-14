class Album < ActiveRecord::Base
  attr_accessible :name
  has_many :images
  
  validates_uniqueness_of :name

  def cover
    self.images.first.path
  end  
  
end  
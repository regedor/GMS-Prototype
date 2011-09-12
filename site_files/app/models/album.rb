class Album < ActiveRecord::Base
  attr_accessor :name
  has_many :images
  
  def initialize(*args)
    @name = args[0][:name]
    @images = args[0][:images]
  end  
  
  def cover
    @images.first
  end  
  
end  
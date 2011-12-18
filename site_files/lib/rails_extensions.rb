module MyActiveRecordExtensions

  def delete_all_at(attribute)
    @errors.delete attribute
  end

end

ActiveRecord::Errors.send(:include, MyActiveRecordExtensions)

module ActiveRecordBaseExtension
  def random
    self.find :first, :offset => ( self.count * rand ).to_i
  end
end
ActiveRecord::Base.extend ActiveRecordBaseExtension
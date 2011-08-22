module MyActiveRecordExtensions

  def delete_all_at(attribute)
    @errors.delete attribute
  end

end

ActiveRecord::Errors.send(:include, MyActiveRecordExtensions)

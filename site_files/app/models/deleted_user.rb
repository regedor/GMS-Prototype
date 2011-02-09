class DeletedUser < User

  # Unchecks deleted
  def undelete!
    self.deleted = false
    save
  end  
  
  def destroy
    begin
      DeletedUser.find(self.id).delete
    rescue
     flash[:warning] = as_(:cant_destroy_record, user.to_label)
     self.successful = false
    end
  end
  
  default_scope :conditions => {:deleted => true}

  # ==========================================================================
  # Class Methods
  # ==========================================================================
  public
  class << self
  end  
end

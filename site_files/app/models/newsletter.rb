class Newsletter

  attr_accessor :name, :email

  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def valid_email?
    begin
      TMail::Address.parse(self.email)
      return true if self.email =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
      return false
    rescue
      return false
    end
  end
end

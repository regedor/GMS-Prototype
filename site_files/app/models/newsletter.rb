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
      return true
    rescue TMail::SyntaxError
      return false
    end
  end
end

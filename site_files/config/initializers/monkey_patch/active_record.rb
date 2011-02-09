module ActiveRecordPatch
  def boolean_attr_accessor(attribute, options={})
    attribute = attribute.to_s
    falsifier = options[:falsifier] || "de"+attribute
    trueifier = options[:trueifier] || attribute
    question  = options[:question]  || attribute+"?"
    class_eval "def #{trueifier}  ; self.#{attribute}=true  ;             end"
    class_eval "def #{falsifier}  ; self.#{attribute}=false ;             end"
    class_eval "def #{trueifier}! ; self.#{attribute}=true  ; self.save ; end"
    class_eval "def #{falsifier}! ; self.#{attribute}=false ; self.save ; end"
    class_eval "def #{question}   ; self.#{attribute}       ;           ; end"
  end
end

ActiveRecord::Base.extend ActiveRecordPatch

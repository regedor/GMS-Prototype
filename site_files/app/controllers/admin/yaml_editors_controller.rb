class Admin::YamlEditorsController < Admin::BaseController
  
  
  def index
    @editor = YamlEditor.new
    @editor.load("config/config.yml",{"development.theme"=>{"title"=>"xxx","type"=>"text_field","options"=>{"x"=>"y"}}})
  end 
  
  def update
    keys = ["development.theme"]
    editor = YamlEditor.new
    editor.load("config/config.yml")
    
    params.each do |key,value|
      editor.set_value_from_path(key,value) if keys.member? key
    end
    
    editor.save
    
    redirect_to :action=> "index"
  end
  
end  



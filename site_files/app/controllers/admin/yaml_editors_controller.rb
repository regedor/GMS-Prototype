class Admin::YamlEditorsController < Admin::BaseController
  
  def index
    @editor = YamlEditor.new
    @editor.load("config/config.yml",{"development.theme"=>{"title"=>"xxx","type"=>"text_field","options"=>{"x"=>"y"}}})
  end 
  
  def update
    p params[:hash]
    
    redirect_to :action=> "index"
  end
  
end  



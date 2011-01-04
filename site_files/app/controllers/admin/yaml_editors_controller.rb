class Admin::YamlEditorsController < Admin::BaseController
  
  
  def index
    @editor = YamlEditor.new
    @editor.load("config/config.yml",create_options_hash)
    
     render :inline => @editor.render, :layout => true
  end 
  
  def update
    keys = ["development.theme","development.title"]
    editor = YamlEditor.new
    editor.load("config/config.yml",create_options_hash)
    
    params.each do |key,value|
      editor.set_value_from_path(key,value) if keys.member? key
    end
    
    editor.save
    
    redirect_to :action=> "index"
  end
  
  private
  
  def create_options_hash
    return {"development.theme"=>{"title"=>"Theme","type"=>"select","options"=>{"simon"=>"simon","theme"=>"Theme"}},
    "development.title"=>{"title"=>"Title","type"=>"text_field"}}
  end  
  
end  



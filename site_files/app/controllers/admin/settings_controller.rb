class Admin::SettingsController < Admin::BaseController
  #filter_access_to :all, :require => any_as_privilege
  
  before_filter :create_options_hash
  
  def index
    render :inline => @editor.render, :layout => true
  end 
  
  def update
    @editor.update_attributes params
    @editor.save
    flash[:notice]=t("flash.changes_saved_successful_with_delay")
    
    redirect_to :action=> "index"
  end
  
  private
  
  def create_options_hash
    @editor = YamlEditor.new(
     {"yaml_editor_title"=>"Titulo",
      "config/config.yml"=> {"development.theme"=> {"title"=>"Theme",
                                                    "type"=>"select",
                                                    "options"=>{"simon"=>"simon","theme"=>"Theme"}
                                                   },
                             "development.title"=> {"title"=>"Title",
                                                    "type"=>"text_field"
                                                   }
                             }
     })
    #@editor = YamlEditor.new({"config/config.yml"=>:all})
  end  
  
end  



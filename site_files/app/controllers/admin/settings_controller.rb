class Admin::SettingsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  
  before_filter :create_options_hash
  
  def index
    @setting = Setting.find_by_identifier "frontend_navigation"  
    render :edit
    #render :inline => @editor.render, :layout => true
  end
  
  def create
    Setting.add_list_item params[:setting][:item_name], params[:setting][:item_link]
    
    redirect_to root_url
  end
  
  def edit
    @setting = Setting.find_by_identifier "frontend_navigation"
  end
  
  def update
    #@editor.update_attributes params
    #flash[:notice]=t("flash.changes_saved_successful_with_delay")
    #
    #redirect_to :action=> "index"
    
    setting = Setting.find params[:id]
    setting.update_attributes params[:setting]

    redirect_to root_url
  end
  
  private
  
  def create_options_hash
    @editor = YamlEditor.new(
     {"yaml_editor_title"=> t("admin.settings.title"),
      "config/config.yml"=> {"development.theme"=> {"title"=>t("admin.settings.theme"),
                                                    "type"=>"select",
                                                    "options"=>{"simon"=>"simon","theme"=>"Theme"}
                                                   },
                             "development.title"=> {"title"=>t("admin.settings.site_title"),
                                                    "type"=>"text_field"
                                                   }
                             }
     })
    #@editor = YamlEditor.new({"config/config.yml"=>:all})
  end  
  
end  



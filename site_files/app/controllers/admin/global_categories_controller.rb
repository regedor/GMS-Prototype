class Admin::GlobalCategoriesController < Admin::BaseController
  
  def set_category
    $current_category = GlobalCategory.find params[:option_id]
    respond_to do |format|
      format.js { render :text => "OK" }
    end
  end
  
end
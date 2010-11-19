class Admin::TagsController < Admin::BaseController

  active_scaffold :tag do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create
    config.actions << :update
    config.actions << :delete

    config.update.columns = :name

    Scaffoldapp::active_scaffold config, "admin.tags", [
      :name, :taggings_count
    ]
  end

#
#  make_resourceful do
#    actions :all
#
#    after(:update) do
#      flash[:notice] = "Tag updated"
#    end
#
#    response_for(:update) do
#      redirect_to(:action => 'index')
#    end
#  end
#
#  protected
#
#  def current_objects
#    @current_object ||= current_model.paginate(
#      :order => "name",
#      :page => params[:page]
#    )
#  end
end

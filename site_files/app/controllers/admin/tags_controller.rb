class Admin::TagsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  active_scaffold :tag do |config|
    Scaffoldapp::active_scaffold config, "admin.tags",
    :list         => [ :name, :taggings_count ], 
    :show         => [ :name, :taggings_count ],
    :edit         => [ :name ]
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

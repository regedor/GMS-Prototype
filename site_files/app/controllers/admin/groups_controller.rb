class Admin::GroupsController < Admin::BaseController
  active_scaffold :group do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete

    Scaffoldapp::active_scaffold config, "admin.groups", [
      :name, :mailable, :description, :parent_group
    ], true
  end
end  
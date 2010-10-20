class Admin::UsersController < Admin::BaseController
  active_scaffold :user do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete

    Scaffoldapp::active_scaffold config, "admin.users", [
      :created_at, :email, :active, :language, :name, :role
    ], true
  end

end

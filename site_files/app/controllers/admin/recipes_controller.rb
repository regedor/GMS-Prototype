class Admin::RecipesController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  active_scaffold :recipe do |config|

    Scaffoldapp::active_scaffold config, "admin.recipes",
      :list         => [ :name, :number_of_people, :duration_in_minutes ],
      :show         => [ :name, :number_of_people, :duration_in_minutes ],
      :edit         => [ :name, :number_of_people, :duration_in_minutes ]
  end

end

class Admin::FrenchAssociationsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
    
  active_scaffold :french_association do |config|
    config.list.sorting = {:name => :asc}
    Scaffoldapp::active_scaffold config, "admin.associations",
      :list   => [ :name, :phone_no, :postal_code,:consulate ],
      :show   => [ ],
      :create => [ ],
      :edit   => [ ]
  end

end

ActionController::Routing::Routes.draw do |map|

  # ==========================================================================
  # Admin Resources
  # ==========================================================================

  map.namespace :admin do |admin|
    admin.resources :activities,          :active_scaffold => true, :active_scaffold_sortable => true 
  end

end

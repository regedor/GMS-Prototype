ActionController::Routing::Routes.draw do |map|

  # ==========================================================================
  # Admin Resources
  # ==========================================================================

  map.namespace :admin do |admin|
    admin.resources :events,          :active_scaffold => true, :active_scaffold_sortable => true 
    admin.resources :events,          :member => { :userUpdate => :post }
    admin.resources :events,          :member => { :delete => :get }
    admin.resources :events do |event|
      event.resources :event_activities,      :member => { :delete => :get }
      event.resources :event_activity_manage, :collection => { :confirmUpdate => :post }
      event.resources :event_manage,          :member => { :index => :get },
                                              :collection => { :confirmUpdate => :post }
    end
    
  end

  

end

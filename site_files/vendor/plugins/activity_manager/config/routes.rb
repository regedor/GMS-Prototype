ActionController::Routing::Routes.draw do |map|

  # ==========================================================================
  # Admin Resources
  # ==========================================================================

  map.namespace :admin do |admin|
    admin.resources :projects,          :active_scaffold => true, :active_scaffold_sortable => true 
    admin.resources :projects do |project|
      project.resources :to_do_lists,   :collection => { :sortList => :post },
                                        :member => { :changeState => :post, :cancel => :get}
      project.resources :to_dos,        :collection => { :new         => :post }
                                        
    end
    
  end

  

end

ActionController::Routing::Routes.draw do |map|

  # ==========================================================================
  # Admin Resources
  # ==========================================================================

  map.namespace :admin do |admin|
    admin.resources :projects,          :active_scaffold => true, :active_scaffold_sortable => true 
    admin.resources :projects do |project|
      project.resources :to_do_lists,   :collection => { :changeState => :post }    
      project.resources :to_dos,        :collection => { :new         => :post }
      project.resources :messages,      :active_scaffold => true, :active_scaffold_sortable => true, :has_many => :messages_comments
      project.resources :messages_comment, :collection => {:create => :post}
      
    end
    
  end

  

end

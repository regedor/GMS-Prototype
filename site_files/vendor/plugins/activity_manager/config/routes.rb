ActionController::Routing::Routes.draw do |map|

  # ==========================================================================
  # Admin Resources
  # ==========================================================================

  map.namespace :admin do |admin|
    admin.resources :projects,          :active_scaffold => true, :active_scaffold_sortable => true 
    
    admin.resources :projects do |project|
      project.resources :to_do_lists,   :collection => { :sortList => :post },
                                        :member => { :changeState => :post, :cancel => :get}
      project.resources :to_dos,        :collection => { :create => :post }
      
      project.resources :to_dos do |todo|
        todo.resources  :comments,      :controller  => "to_do_comments", :collection => { :preview => :post }
      end  
      project.resources :categories
      project.resources :messages,      :active_scaffold => true, :active_scaffold_sortable => true, :has_many => :messages_comments
      project.resources :messages_comment, :collection => {:create => :post} 
    end   
    
  end
end

ActionController::Routing::Routes.draw do |map|
  map.root :controller => "pages", :action => "root_page"

  # ==========================================================================
  # User Resources
  # ==========================================================================
  map.page '/page/:action', :controller => "pages"

  # ==========================================================================
  # Session Resources
  # ==========================================================================
  map.resources :groups
  
  map.resources :users
  map.resource  :account,  :controller => "users"
  map.resources :user_password_resets
  map.resource  :user_session, :member => { :send_invitations => :post }
  map.language  '/user_session/language/:language', :controller => 'user_sessions', :action => 'language'
  map.logout    '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login     '/login',  :controller => 'user_sessions', :action => 'new'
  map.activate  '/activate/:activation_code', :controller => 'users', :action => 'activate'

  # ==========================================================================
  # Admin Resources
  # ==========================================================================
  map.namespace :admin do |admin|
    admin.root :controller => 'dashboard', :action => 'index'
    admin.resources :groups
    admin.resources :settings
    admin.resources :announcements
    admin.resources :commits
    admin.resources :users, :member => { :suspend   => :put,
                                         :unsuspend => :put,
                                         :activate  => :put, 
                                         :reset_password => :put },
                            :collection => { :pending   => :get,
                                             :active    => :get, 
                                             :suspended => :get, 
                                             :deleted   => :get }
    admin.resources :posts, :new => {:preview => :post}
    admin.resources :pages, :new => {:preview => :post}
    admin.resources :comments, :member => {:mark_as_spam => :put, :mark_as_ham => :put}
    admin.resources :tags
    admin.resources :undo_items, :member => {:undo => :post}

    map.connect '/admin/:controller/:action/:id'
  end
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end

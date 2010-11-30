ActionController::Routing::Routes.draw do |map|

  map.root :controller => "pages", :action => "root_page"
  # ==========================================================================
  # User Resources
  # ==========================================================================
  map.page '/page/:action', :controller => "pages"
  map.resources :posts

  # ==========================================================================
  # Session Resources
  # ==========================================================================
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
    admin.resources :users,          :active_scaffold => true, :active_scaffold_sortable => true,
                                     :member          => { :suspend => :put,:unsuspend => :put, :activate => :put,:reset_password => :put },
                                     :collection      => { :pending => :get,:active => :get,:do_action => :get,:suspended => :get,:deleted => :get }
    admin.resources :groups,         :active_scaffold => true, :active_scaffold_sortable => true
    admin.resources :settings,       :active_scaffold => true, :active_scaffold_sortable => true
    admin.resources :announcements,  :active_scaffold => true, :active_scaffold_sortable => true
    admin.resources :commits,        :active_scaffold => true, :active_scaffold_sortable => true
    admin.resources :posts,          :active_scaffold => true, :active_scaffold_sortable => true,
                                     :has_many        =>  [ :comments, :tags ],
                                     :new             =>  { :preview => :post },
                                     :member          =>  { :update_tag => :put }
    admin.resources :pages,          :active_scaffold => true, :active_scaffold_sortable => true,
                                     :new        =>    { :preview => :post }
    admin.resources :comments,       :active_scaffold => true, :active_scaffold_sortable => true,
                                     :member     =>    { :mark_as_spam => :put,
                                     :mark_as_ham => :put }
    admin.resources :tags,           :has_many => :posts
    admin.resources :action_entries, :active_scaffold => true, :active_scaffold_sortable => true,
                                     :member     =>    { :undo => :post }
  end
  
  # ==========================================================================
  # API Resources
  # ==========================================================================
  map.namespace :api do |api|
   api.resource :i18n
  end

end

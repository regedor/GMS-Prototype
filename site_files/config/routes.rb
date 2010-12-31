ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'posts', :action => 'index'


  # ==========================================================================
  # Frontend Resources
  # ==========================================================================

  map.archives '/archives', :controller => 'archives', :action => 'index'

  map.resources :posts, :except => :show
  #map.resources :pages

  map.connect ':year/:month/:day/:slug/comments', :controller => 'comments', :action => 'create', :method => :post
  map.connect ':year/:month/:day/:slug', :controller => 'posts', :action => 'show', :requirements => { :year => /\d+/ }
  #map.posts_with_tag ':tag', :controller => 'posts', :action => 'index'
  #map.formatted_posts_with_tag ':tag.:format', :controller => 'posts', :action => 'index'


  # ==========================================================================
  # User Resources
  # ==========================================================================

  map.namespace :user do |user|
    user.resource  :account,                            :controller => 'account'
    user.resources :accounts,                           :controller => 'account'
    user.resource  :password_reset
    user.resource  :session,                           :controller => 'session', :member => { :send_invitations => :post }
    user.logout    'session/end',                      :controller => 'session', :action => 'destroy'
    user.language  '/user_session/language/:language', :controller => 'session', :action => 'language'
    user.activate  '/activate/:activation_code',       :controller => 'account', :action => 'activate'
  end


  # ==========================================================================
  # Admin Resources
  # ==========================================================================

  map.namespace :admin do |admin|
    admin.root :controller => 'dashboard', :action => 'index'
    admin.resources :users,          :active_scaffold => true, :active_scaffold_sortable => true,
                                     :member          => { :delete => [:get,:put], :suspend => :put, :unsuspend => :put, :activate => :put, 
                                                           :reset_password => :put },
                                     :collection      => { :list_action => :post }
    admin.resources :deleted_users,  :active_scaffold => true, :active_scaffold_sortable => true,
                                     :member          => { :undelete    => [:get,:put] },
                                     :collection      => { :list_action => :post }
    admin.resources :groups,         :active_scaffold => true, :active_scaffold_sortable => true,
                                     :collection      => { :list_action => :post }
    admin.resources :settings,       :active_scaffold => true, :active_scaffold_sortable => true,
                                     :collection      => { :list_action => :post }
    admin.resources :announcements,  :active_scaffold => true, :active_scaffold_sortable => true,
                                     :collection      => { :list_action => :post }
    admin.resources :commits,        :active_scaffold => true, :active_scaffold_sortable => true,
                                     :collection      => { :list_action => :post }
    admin.resources :posts,          :active_scaffold => true, :active_scaffold_sortable => true,
                                     :has_many        => :comments,
                                     :new             => { :preview => :post },
                                     :member          => { :check_delete => [:get, :post], :edit_tag => :get, :update_tag => :put },
                                     :collection      => { :list_action => :post }
    admin.resources :pages,          :active_scaffold => true, :active_scaffold_sortable => true,
                                     :new             => { :preview => :post },
                                     :collection      => { :list_action => :post }
    admin.resources :comments,       :active_scaffold => true, :active_scaffold_sortable => true,
                                     :only            => :destroy,
                                     :member          => { :mark_as_spam => :put, :mark_as_ham => :put }
    admin.resources :tags,           :has_many        => :posts
    admin.resources :history_entries
    admin.resources :yaml_editors
  end

  
  # ==========================================================================
  # API Resources
  # ==========================================================================

  map.namespace :api do |api|
   api.resource :i18n
  end
  

  # ==========================================================================
  # Website Resources
  # ==========================================================================

  map.namespace :website do |website|
    website.root :controller => 'posts', :action => 'index'
	 website.resources :posts
  end


end

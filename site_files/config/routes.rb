ActionController::Routing::Routes.draw do |map|
  map.resources :settings


  map.root :controller => 'posts', :action => 'index'
  # sparklines route
  map.sparklines '/sparklines', :controller => 'admin/sparklines', :action => 'index'

  # ==========================================================================
  # Frontend Resources
  # ==========================================================================

  map.resources :posts
  map.resources :calendar
  map.resources :albums
  map.resource  :newsletter
  
  map.resources :sys_admin, :collection => { :log => :get, :update_current_user => :put }
  
  map.connect ':slug/comments', :controller => 'comments', :action => 'create', :method => :post
  map.page ':slug', 
          :controller => 'pages', 
          :action => 'show', 
          :method => :get, 
          :requirements => { :slug => /(?!admin).*/ }
  
  map.global_category ':name/posts', 
                      :controller => 'posts', 
                      :action => 'index', 
                      :method => :get,
                      :requirements => {:name  => /(#{GlobalCategory.all.map(&:slug).join('|')})/}
                      
  map.connect ':name/:year/:month/:day/:slug/comments', 
          :controller => 'comments', 
          :action => 'create', 
          :method => :post,
          :requirements => { 
            :name  => /(#{GlobalCategory.all.map(&:slug).join('|')})/,
            :year => /\d+/, 
            :month => /\d+/, 
            :day => /\d+/ 
          }
  map.connect ':name/:year/:month/:day/:slug',          
          :controller => 'posts', 
          :action => 'show',
          :requirements => { 
            :name  => /(#{GlobalCategory.all.map(&:slug).join('|')})/,
            :year => /\d+/, 
            :month => /\d+/, 
            :day => /\d+/ 
          }

  map.connect ':year/:month/:day/:slug/comments', :controller => 'comments', :action => 'create', :method => :post,
                                                  :requirements => { :year => /\d+/, :month => /\d+/, :day => /\d+/ }
  map.connect ':year/:month/:day/:slug',          :controller => 'posts', :action => 'show',
                                                  :requirements => { :year => /\d+/, :month => /\d+/, :day => /\d+/ }

  map.posts_with_tags 'tags/:tags', :controller => 'posts', :action => 'index'

  map.archives '/archives', :controller => 'posts', :action => 'archives'

  # ==========================================================================
  # User Resources
  # ==========================================================================

  map.namespace :user do |user|
    user.resources :accounts,                          :controller => 'account', :only => [ :index, :show ]
    user.resource  :account,                           :controller => 'account'
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
                                     :member          => { :check_delete => [:get, :post], :edit_tag => :get, :update_tag => :put, :values => :get, :download => :get},
                                     :collection      => { :list_action => :post, :preview => :post, :values => :get }
    admin.resources :pages,          :active_scaffold => true, :active_scaffold_sortable => true,
                                     :has_many        => :comments,
                                     :new             => { :preview => :post },
                                     :collection      => { :list_action => :post, :preview => :post }
    #solinho hack
    admin.resources :comments,       :active_scaffold => true, :active_scaffold_sortable => true,
                                     :member          => { :mark_as_spam => :put, :mark_as_ham => :put }
    admin.resources :history_entries
    admin.resources :settings
    admin.resources :global_categories, :collection => { :set_category => :get }
    admin.resources :mails,          :active_scaffold => true, :active_scaffold_sortable => true, 
                                     :collection      => { :values => :get }     
    admin.resources :user_optional_group_picks, :active_scaffold => true, :active_scaffold_sortable => true      
    admin.posts_with_tags 'posts/tags/:tag_ids', :controller => 'posts', :action => 'index'
    
    # ==========================================================================
    # Projects Resources
    # ==========================================================================
    
    
    admin.resources :projects,          :active_scaffold => true, :active_scaffold_sortable => true 
    
    admin.resources :projects do |project|
      project.resources :to_do_lists,   :collection => { :sortList => :post },
                                        :member => { :changeState => :post, :cancel => :get}
      project.resources :to_dos,        :collection => { :create => :post }
      
      project.resources :to_dos do |todo|
        todo.resources  :comments,      :controller  => "to_do_comments", :member => { :download => :post}, :collection => { :preview => :post}
      end  
      project.resources :categories,    :collection => {:create => :post}
      project.resources :messages,      :active_scaffold => true, :active_scaffold_sortable => true, :has_many => :messages_comments
      project.resources :messages_comment, :collection => {:create => :post} 
    end
    
    admin.resources :albums,             :active_scaffold => true, 
                                         :active_scaffold_sortable => true, 
                                         :has_many => :images,
                                         :member => { :all_images => :get }
    admin.resources :images
  end

  
  # ==========================================================================
  # API Resources
  # ==========================================================================

  map.namespace :api do |api|
   api.resource  :i18n
   api.resources :create_groups,  :collection => {:create_group => :post}
  end
end

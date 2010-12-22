authorization do

  role :root do
    includes :admin
    has_permission_on [:admin_root_groups],         :to => [:read]
  end

  role :admin do
    includes :users_manager
    includes :website_manager 
    has_permission_on [:user_roles],                :to =>  [ :as_manage ]
  end


  ##########################################################################################################

  role :users_manager do
    includes :user
    has_permission_on [:admin_dashboard],           :to => [:read]
    has_permission_on [:admin_users],               :to =>  [ :as_manage ]
    has_permission_on [:admin_groups],              :to =>  [ :as_manage ]
  end


  ##########################################################################################################

  role :website_manager do
    includes :blogger
    has_permission_on [:admin_posts],               :to =>  [ :as_manage ]
    has_permission_on [:admin_announcements],       :to =>  [ :as_manage ]
    has_permission_on [:admin_pages],               :to =>  [ :as_manage ]
    has_permission_on [:admin_users],               :to =>  [ :as_read ]
    has_permission_on [:admin_groups],              :to =>  [ :as_read ]
  end


  role :blogger do
    includes :user
    has_permission_on [:admin_dashboard],           :to => [:read]
    has_permission_on [:admin_unpublished_posts],   :to =>  [ :as_manage ]
  end

  role :user do
    includes :guest
    has_permission_on [:comments],                  :to => [:create]
  end

  role :guest do
    has_permission_on :posts,                       :to =>  [ :read ]
    has_permission_on :pages,                       :to =>  [ :read ]
    #has_permission_on :pagess,                     :to => [:read] do
    #  if_attribute :user => is { user }
    #end
  end
  
end

privileges do
  
  privilege :manage do
    includes :create, :read, :update, :delete
  end

  privilege :as_manage do
    includes :as_read, :as_create, :as_update, :as_delete
  end
  
end


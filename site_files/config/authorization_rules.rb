authorization do

  role :root do
    includes :guest
    includes :admin
    has_permission_on [:admin_dashboard], :to => [:read]
  end

  role :admin do
    includes :guest

    has_permission_on [:admin_users], :to =>  [ :as_manage ]
    has_permission_on [:admin_groups], :to =>  [ :as_manage ]

    has_permission_on [:articles, :comments], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on :pages, :to => :all
  end

  role :guest do
    has_permission_on :user, :to =>  [ :manage, :read, :update ]
    #has_permission_on :pages, :to => [:root_page, :about, :home]
    #has_permission_on :articles, :to => [:index, :show]
    #has_permission_on :comments, :to => [:new, :create]
    #has_permission_on :comments, :to => [:edit, :update] do
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


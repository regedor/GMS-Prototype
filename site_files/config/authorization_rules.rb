authorization do

  role :root do
    has_omnipotence
  end

  role :admin do
    includes :users_manager
    includes :poject_manager
    includes :website_manager 
    has_permission_on [:admin_history_actions],     :to =>  [ :as_manage ]
    has_permission_on [:user_roles],                :to =>  [ :as_manage ]
    has_permission_on [:admin_mails],               :to =>  [ :as_manage ]
  end
  
  role :poject_manager do
    includes :user
    has_permission_on [:admin_projects],            :to =>  [:create]
  end


  ##########################################################################################################

  role :users_manager do
    includes :user
    has_permission_on [:admin_dashboard],           :to =>  [:read]
    has_permission_on [:admin_users],               :to =>  [ :as_manage ]
    has_permission_on [:admin_deleted_users],       :to =>  [ :as_manage ]
    has_permission_on [:admin_groups],              :to =>  [ :as_manage ]
    has_permission_on [:admin_user_optional_group_picks], :to =>  [ :as_manage ]
    has_permission_on [:history_entries],            :to =>  [ :as_manage ]
  end


  ##########################################################################################################

  role :website_manager do
    includes :blogger
    has_permission_on [:admin_posts],               :to =>  [ :as_manage ]
    has_permission_on [:admin_comments],            :to =>  [ :as_manage ]
    has_permission_on [:admin_announcements],       :to =>  [ :as_manage ]
    has_permission_on [:admin_pages],               :to =>  [ :as_manage ]
    has_permission_on [:admin_users],               :to =>  [ :as_read ]
    has_permission_on [:admin_groups],              :to =>  [ :as_read ]
    has_permission_on [:admin_user_optional_group_picks], :to =>  [ :as_read ]
  end


  role :blogger do
    includes :user
    has_permission_on [:admin_dashboard],           :to =>  [:read]
    has_permission_on [:admin_unpublished_posts],   :to =>  [ :as_manage ]
  end

  role :user do
    includes :guest
    has_permission_on [:comments],                  :to => [:create]
    has_permission_on [:admin_projects],            :to => [:as_read]
    has_permission_on [:admin_to_do_lists],         :to =>  [:manage] do
      if_attribute :users => contains { user }
    end
    has_permission_on [:admin_to_dos],              :to =>  [:manage] do
      if_attribute :users => contains { user }
    end
    has_permission_on [:admin_messages],            :to =>  [:read] do
      if_attribute :project => { :users => contains { user } }
    end
    has_permission_on [:admin_messages],            :to => [:manage] do
      if_attribute :user => is { user }
    end
    has_permission_on [:admin_messages_comments],    :to =>  [:create] do
      if_attribute :project => { :users => contains { user } }
    end
  end

  role :guest do
    has_permission_on :posts,                       :to =>  [ :read ]
    has_permission_on :pages,                       :to =>  [ :read ]
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


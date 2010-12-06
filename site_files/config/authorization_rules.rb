authorization do

  role :root do
   # includes :guest
    has_permission_on [:admin_dashboard], :to => [:read]
  end

  role :admin do
    includes :guest
    has_permission_on [:articles, :comments], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on :pages, :to => :all
  end

  role :guest do
    #has_permission_on :pages, :to => [:root_page, :about, :home]
    #has_permission_on :articles, :to => [:index, :show]
    #has_permission_on :comments, :to => [:new, :create]
    #has_permission_on :comments, :to => [:edit, :update] do
    #  if_attribute :user => is { user }
    #end
  end
  
end

class Admin::FrenchAssociationsController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
    
  active_scaffold :french_association do |config|
    config.list.sorting = {:name => :asc}
    Scaffoldapp::active_scaffold config, "admin.associations",
      :list   => [ :name, :phone_no, :postal_code, :consulate ],
      :create => [ :name, :phone_no, :postal_code, :consulate, :address, :email, :website, :fax ],
      :edit   => [ ]
  end
  
  def new
    @association = FrenchAssociation.new
  end
  
  def create
    @association = FrenchAssociation.new params[:french_association]
    if @association.save
      flash[:notice] = t('flash.associationCreated.successfully', :name => @association.name)
      redirect_to admin_associations_path
    else
      flash.now[:error] = t('flash.associationCreated.error')
      render :new
    end
  end
  
  def edit
    @association = FrenchAssociation.find params[:id]
  end
  
  def destroy
    assoc = FrenchAssociation.find(params[:id])
    if assoc.destroy
      flash[:notice] = t("flash.association_deleted",:assoc => assoc.name)
    else
      flash[:error] = t("flash.association_deletion_fail",:assoc => assoc.name)
    end
    
    redirect_to admin_french_associations_path
  end

end

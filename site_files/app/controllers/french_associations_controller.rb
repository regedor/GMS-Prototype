class FrenchAssociationsController < ApplicationController

  def index
    @associations = (params[:code]) ? Department.find_by_code(params[:code]).french_associations : FrenchAssociation.all
  end
  
  def show
    @association = FrenchAssociation.find params[:id]
  end

end
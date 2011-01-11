class PagesController < ApplicationController
  before_filter :find_page
  #filter_access_to :show, :attribute_check => true


  # ==========================================================================
  # Protected Methods
  # ==========================================================================
  protected

  def find_page
    @page = Page.find_by_slug(params[:slug]) || raise(ActiveRecord::RecordNotFound)
  end

end

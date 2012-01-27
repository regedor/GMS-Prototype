class PagesController < ApplicationController
  before_filter :find_page
  #filter_access_to :show, :attribute_check => true


  # ==========================================================================
  # Protected Methods
  # ==========================================================================
  protected

  def find_page
    @page = Page.viewable_only(current_user).find_by_slug(params[:slug])
    if !@page
      flash[:notice] = t('flash.not_permitted')
      redirect_to root_path
      return
    end
    @comment = Comment.new if @page.has_comments
  end

end

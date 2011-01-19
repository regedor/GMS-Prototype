class Admin::HistoryEntriesController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  def create
    @history_entry  = HistoryEntry.find(params[:id])
    @history_entry.revert!
    flash[:notice] = t 'flash.reverted_with_sucess'
    redirect_to params[:redirect_url]
  end
end

class Admin::HistoryEntriesController < Admin::BaseController
  filter_access_to :all, :require => write_as_privilege
  filter_access_to [:index,:show], :require => [:as_read]

  def create
    @history_entry  = HistoryEntry.find(params[:id])
    @history_entry.revert!
    flash[:notice] = t 'flash.reverted_with_sucess'
    redirect_to params[:redirect_url]
  end
end

class Admin::VideosController < Admin::BaseController
  filter_access_to :all, :require => write_as_privilege
  filter_access_to [:index,:show], :require => [:as_read]
  
  def upload
    @upload_info = yt_client.upload_token({:title => "test", 
                                           :description => "desc", 
                                           :category => "Sports", 
                                           :keywords => ["test"],
                                           :private => true}, videos_url)
  end
  
end
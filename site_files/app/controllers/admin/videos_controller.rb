class Admin::VideosController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege
  
  def upload
    @upload_info = yt_client.upload_token({:title => "test", 
                                           :description => "desc", 
                                           :category => "Sports", 
                                           :keywords => ["test"],
                                           :private => true}, videos_url)
  end
  
end
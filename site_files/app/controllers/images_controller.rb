class ImagesController < ApplicationController

  def create
    @image = Image.new :multi_purpose_image => params[:image][:multi_purpose_image].first
    if @image.save
      render :json => [{
        :url => @image.multi_purpose_image.url.to_s,
        :name => @image.multi_purpose_image.instance.attributes["multi_purpose_image_file_name"],
        :delete_url => image_path(@image),
        :delete_type => "DELETE"
      }], :content_type => 'text/html'
    else
      render :json => { :result => 'error'}, :content_type => 'text/html'
    end
  end
  
  def destroy
    @image = Image.find params[:id]
    @image.destroy
    render :json => { :result => true}, :content_type => 'application/json'
  end

end

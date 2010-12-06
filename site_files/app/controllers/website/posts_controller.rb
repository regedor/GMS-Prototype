class Website::PostsController < ApplicationController

	before_filter :find_post, :only => [:show]

	def index
		respond_to do |format|
			format.html{
				@posts = Post.paginate_by_published_date(params[:page])
				@announcements = Announcement.active
			}
		end
	end

	def show
		respond_to do |format|
			format.html{
				render :partial => 'post',:locals => {:post => @post} 
			}
		end
	end
	
	def find_post
		@post = Post.find(params[:id])
	end

end

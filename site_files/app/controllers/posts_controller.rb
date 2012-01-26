class PostsController < ApplicationController
  def index
    @tags = params[:tags].split(",") if params[:tags]
    if params[:name]
      category = GlobalCategory.find_by_slug(params[:name])
      @posts = Post.filter_by_category(category.id).paginate_with_tag_names(params[:search],current_user,@tags,params[:page])
    else
      @posts = Post.paginate_with_tag_names(params[:search],current_user,@tags,params[:page])
    end

    respond_to do |format|
      format.html {
         
      }
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    @comment = Comment.new
    @event = @post.event
    @subscribed_activities = (current_user && @event) ? EventActivitiesUser.find_all_by_user_id_and_event_id_and_status_id(current_user.id,@event.id,2) : nil
    @total_price = (current_user && @event) ? @event.total_price(@subscribed_activities) : nil
  end

  def archives
    @months = Post.find_all_grouped_by_month
  end
end

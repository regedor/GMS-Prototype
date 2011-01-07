class PostsController < ApplicationController
  def index
    @tags = params[:tags].split(",") if params[:tags]
    @posts = Post.paginate_with_tag_names(@tags, params[:page])
    @tags_for_cloud = Tag.tags_for_cloud(@tags)

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    @comment = Comment.new
  end

  def archives
    @months = Post.find_all_grouped_by_month
  end
end

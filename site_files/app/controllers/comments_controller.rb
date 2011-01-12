class CommentsController < ApplicationController

  # Required for redirection after post creation
  include UrlHelper

  def create
    type = params[:comment][:type]
    @comment = Comment.new((params[:comment] || {}).reject {|key, value| !Comment.protected_attribute?(key) })
    case type
      when 'Post' then
        @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
        @comment.commentable = @post
      when 'Page' then
        @page = Page.find_by_slug(params[:slug])
        @comment.commentable = @page
    end
    @comment.user_id = current_user.id

    if @comment.save
      case type
        when 'Post' then
          redirect_to post_path(@post)
        when 'Page' then
          redirect_to page_path(@page)
      end
    else
      case type
        when 'Post' then
          render :template => 'posts/show'
        when 'Page' then
          render :template => 'pages/show'
      end
    end
  end

end

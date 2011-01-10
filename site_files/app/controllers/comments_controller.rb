class CommentsController < ApplicationController

  # Required for redirection after post creation
  include UrlHelper

  def create
    @comment = Comment.new((params[:comment] || {}).reject {|key, value| !Comment.protected_attribute?(key) })
    @comment.post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to post_path(@comment.post)
    else
      @post = @comment.post
      render :template => 'posts/show'
    end
  end

end

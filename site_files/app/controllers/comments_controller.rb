class CommentsController < ApplicationController

  # Required for redirection after post creation
  include UrlHelper

  def create
    @comment = Comment.new((session[:pending_comment] || params[:comment] || {}).reject {|key, value| !Comment.protected_attribute?(key) })
    @comment.post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })

    session[:pending_comment] = nil

    if @comment.requires_openid_authentication?
      session[:pending_comment] = params[:comment]
      authenticate_with_open_id(@comment.author, :optional => [:nickname, :fullname, :email]) do |result, identity_url, registration|
        if result.status == :successful

          @comment.author_url   = @comment.author
          @comment.author       = (registration["fullname"] || registration["nickname"] || @comment.author_url).to_s
          @comment.author_email = (registration["email"] || @comment.author_url).to_s

          @comment.openid_error = ""
          session[:pending_comment] = nil
        else
          @comment.openid_error = OPEN_ID_ERRORS[ result.status ]
        end
      end
    else
      @comment.blank_openid_fields
    end

    if @comment.save
      redirect_to post_path(@comment.post)
    else
      render :template => 'posts/show'
    end
  end

end

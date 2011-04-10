class CommentsController < ApplicationController

  # Required for redirection after post creation
  include UrlHelper

  #Required for error messages
  include CommentsHelper

  def create
    @type = params[:comment][:type]
    generate_comment
    if @comment.save 
      flash[:notice] = I18n::t('comments.success')
    else
      flash[:error] = format_comment_error
    end
    case @type
      when 'Post' then
        redirect_to Hash[*[:year, :month, :day, :slug].map { |x| [x,params[x]] }.flatten].merge :controller => 'posts', :action => 'show'
      when 'Page' then
        redirect_to page_path(@page)
    end
  end

  protected

    def generate_comment
      @comment = Comment.new((params[:comment] || {}).reject {|key, value| !Comment.protected_attribute?(key) })
      case @type
        when 'Post' then
          @post = Post.find_by_permalink(*[:year, :month, :day, :slug].map {|x| params[x] })
          @comment.commentable = @post
        when 'Page' then
          @page = Page.find_by_slug(params[:slug])
          @comment.commentable = @page
      end
      begin; @comment.user_id = current_user.id; rescue; end;
    end

end

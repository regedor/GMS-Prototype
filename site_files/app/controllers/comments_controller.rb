class CommentsController < ApplicationController

  # Required for redirection after post creation
  include UrlHelper

  #Required for error messages
  include CommentsHelper

  def create
    @type = params[:comment][:type]
    generate_comment
    @comment.save ? success : insuccess
  end

  protected

    def generate_comment
      @comment = Comment.new((params[:comment] || {}).reject {|key, value| !Comment.protected_attribute?(key) })
      case @type
        when 'Post' then
          @post = Post.find_by_permalink(*[:year, :month, :day, :slug].collect {|x| params[x] })
          @comment.commentable = @post
        when 'Page' then
          @page = Page.find_by_slug(params[:slug])
          @comment.commentable = @page
      end
      begin; @comment.user = current_user; rescue; end;
    end

    def success
      flash[:notice] = I18n::t('comments.success')
      case @type
        when 'Post' then
          redirect_to post_path(@post)
        when 'Page' then
          redirect_to page_path(@page)
      end
    end

    def insuccess
      flash[:error] = format_comment_error
      case @type
        when 'Post' then
          redirect_to :controller => 'posts', :action => 'show'
        when 'Page' then
          redirect_to :controller => 'pages', :action => 'show'
      end
    end

end

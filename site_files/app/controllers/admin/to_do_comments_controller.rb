class Admin::ToDoCommentsController < Admin::BaseController

  def new
    @todo = ToDo.find(params[:to_do_id])
    @comment = ToDoComment.new
    @project = Project.find(params[:project_id])
  end

  def create
    comment = ToDoComment.new params[:to_do_comment]
    comment.user     = current_user
    comment.to_do_id = params[:to_do_id]
    if comment.save
      flash[:notice] = t("flash.to_do_comment_created", :todo => comment.to_do.description)
      if params[:to_do_comment][:users] and (params[:to_do_comment][:users].map(&:blank?).member? true)
        mail = Mail.new :message => current_user.name+"&sep&"+params[:to_do_id].to_s+"&sep&"+comment.id.to_s,
          :sent_on => Time.now,
          :subject => t("notifier.to_do_notification.comment_subject")

        mailing_list = []
        params[:to_do_comment][:users].reject(&:blank?).each do |user_id|
          mailing_list << User.find(user_id)
        end
        mail.recipients = mailing_list
        mail.set_xmls(mailing_list)
        mail.message_type = "email"
        mail.save

        begin
          mailing_list.each do |user|
            Notifier.deliver_new_to_do_comment_notification(user,mail)
          end
        rescue Exception
          flash[:error] = t("flash.mail_not_sent_multiple")
          redirect_to new_admin_project_to_do_comment_path(params[:project_id],params[:to_do_id])
          return false
        end
      end
    else
      @template.properly_show_errors(mail)
      flash[:error] = t("flash.to_do_comment_creation_fail")
    end

    redirect_to new_admin_project_to_do_comment_path(params[:project_id],params[:to_do_id])
  end

  def preview
    @comment = ToDoComment.build_for_preview(params[:to_do_comment])

    respond_to do |format|
      format.js {
        render :partial => 'preview', :locals => {:comment => @comment}
      }
    end

  end

  def download
    comment = ToDoComment.find(params[:id])

    send_file comment.generic.path, :type=>comment.generic_content_type#, :x_sendfile=>true
    # check this before use http://www.therailsway.com/2009/2/22/file-downloads-done-right
  end

end

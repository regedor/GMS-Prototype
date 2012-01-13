class NewslettersController < ApplicationController

  def create
    newsletter = Newsletter.new params[:newsletter]

    if !newsletter.valid_email?
      flash[:error] = t("flash.newsletter.invalid_email_or_name")
      redirect_to root_path
      return
    end

    begin
      Notifier.deliver_newsletter_notification(newsletter)
      flash[:notice] = t("flash.newsletter.will_be_notified")
    rescue Exception
      flash[:error] = t("flash.newsletter.mail_not_sent")
    end

    redirect_to root_path
  end

end

class Admin::ToDosController < Admin::BaseController
  filter_access_to :all,
    :require         => :manage,
    :attribute_check => true,
    :load_method     => lambda { Project.find(params[:project_id]) }


  def create
    unless params[:todo][:description].empty?
      todo = ToDo.new
      todo.user_id = params[:todo][:responsible]
      todo.to_do_list_id = params[:todo][:to_do_list_id]
      todo.description = params[:todo][:description]
      begin 
        todo.due_date =  DateTime.strptime(params[:todo][:due_date],"%d/%m/%Y").to_time unless params[:todo][:due_date].blank?
      rescue ArgumentError
        flash[:error] = t("flash.invalid_date")
        redirect_to admin_project_to_do_lists_path(params[:project_id])
        return
      end
      todo.save

      if todo.user
        mail = Mail.create(:message => todo.to_do_list.name, :sent_on => Time.now, :subject => "")

        begin
          Notifier.deliver_to_do_notification(todo.user,mail)
        rescue Exception
          return false
        end
      end
    else
      flash[:error] = t("flash.description_required")
    end  

    redirect_to admin_project_to_do_lists_path(params[:project_id])
  end

  def update
    todo = ToDo.find(params[:id])
    unless todo.done?
      todo.user_id = params[:todo][:user_id]
      todo.to_do_list_id = params[:todo][:to_do_list_id]
      todo.description = params[:todo][:description]
      todo.due_date = params[:todo][:due_date]
      todo.save
    else
      flash[:error] = t("admin.to_do.update.error")
    end

    mail = Mail.create :message => todo.to_do_list

    begin
      Notifier.deliver_mail(todo.user,mail)
    rescue Exception
      return false
    end

    redirect_to admin_project_to_do_lists_path(params[:project_id])
  end

  def destroy
    todo = ToDo.find(params[:id])
    unless todo.done?
      todo.destroy
      respond_to do |format|
        format.js { render :text  => params[:id] }
      end
    else
      flash[:error] = t("admin.to_do.destroy.error")
      redirect_to admin_project_to_do_lists_path(params[:project_id])
    end
  end

end

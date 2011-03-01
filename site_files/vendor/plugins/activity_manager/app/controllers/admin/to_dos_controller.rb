class Admin::ToDosController < Admin::BaseController
  filter_access_to :all,
    :require         => :manage,
    :attribute_check => true,
    :load_method     => lambda { Project.find(params[:project_id]) }


  def create
    unless params[:todo][:description].empty?
      @list = ToDoList.find(params[:todo][:to_do_list_id])
      @project = Project.find(params[:project_id])
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

      if todo.user
        mail = Mail.new    :message => current_user.name+"&sep&"+todo.description+"&sep&"+todo.to_do_list.name,
          :sent_on => Time.now,
          :subject => t("notifier.to_do_notification.new_todo_subject")

        begin
          Notifier.deliver_new_to_do_notification(todo.user,mail)
        rescue Exception
          return false
        end
      end

      if todo.save
        respond_to do |format|
          format.json { render :json  =>  {
                          'id' => params[:todo][:to_do_list_id],
                          'html'=> render_to_string(:partial => "admin/to_do_lists/list.html.erb", :layout => false, :locals => {:list => @list, :project => @project})
                        }
                        }
        end
      end

    else
      flash[:error] = t("flash.description_required")
    end

    #redirect_to admin_project_to_do_lists_path(params[:project_id])
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

    if todo.user
      mail = Mail.new :message => current_user.name+"&sep&"+todo.description+"&sep&"+todo.to_do_list.name,
                      :sent_on => Time.now,
                      :subject => t("notifier.to_do_notification.update_todo_subject")

      mail.recipients = [todo.user]
      mail.set_xmls(todo.user)
      #mail.save

      begin
        Notifier.deliver_update_to_do_notification(todo.user,mail)
      rescue Exception
        flash[:error] = t("flash.mail_not_sent", :mail => todo.user.email)
        redirect_to admin_project_to_do_lists_path(params[:project_id])
        return false
      end
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

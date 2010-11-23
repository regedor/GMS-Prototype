class Admin::SettingsController < Admin::BaseController
  active_scaffold :setting do |config|
    config.actions.swap :search, :live_search
    config.actions.exclude :update, :delete, :show, :create

    config.actions << :show
    config.actions << :update
    config.actions << :delete
    config.actions << :create
    #config.label = I18n::t('admin.users.title')

    config.list.label = I18n::t('settings.index.title')
    config.create.label = I18n::t('settings.new.title')

    # This action_link should be only available to root..
    config.action_links.add 'lockunlock', :label => I18n::t('settings.record.lockunlock'), :type => :record, :page => true

    #list_columns = [:row_mark,:email,:active, :language, :name, :role]
    #config.list.columns = list_columns
    #list_columns.shift

    #list_columns.each { |column| config.columns[column].label = I18n::t('users.index.'+column.to_s) }
#    config.actions.add :mark

    #config.update.link.security_method editable?

    Scaffoldapp::active_scaffold config, "admin.settings", [
      :label, :identifier, :description, :field_type, :value, :editable
    ]
  end

  # This method should be only available to root.
  def lockunlock
    if Setting.send(:editable!,params[:id])
      list
    else
      render :text => "" 
    end
  end  

end

class Admin::SettingsController < Admin::BaseController
  active_scaffold :setting do |config|
    #config.label = I18n::t('admin.users.title')

    config.list.label = I18n::t('settings.index.title')
    config.create.label = I18n::t('settings.new.title')

    #list_columns = [:row_mark,:email,:active, :language, :name, :role]
    #config.list.columns = list_columns
    #list_columns.shift

    #list_columns.each { |column| config.columns[column].label = I18n::t('users.index.'+column.to_s) }
#    config.actions.add :mark

    config.actions.swap :search, :live_search

    Scaffoldapp::active_scaffold config, "admin.settings", [
      :created_at, :email, :active, :language, :name, :role
    ]
  end

end

module Scaffoldapp
  class << self

    def active_scaffold(config, i18n_scope, columns, row_mark_actions_list=nil)
      columns.unshift :row_mark if row_mark_actions_list
      config.label = I18n::t(i18n_scope+".create.title")
      config.list.label = I18n::t(i18n_scope+".index.title")
      begin;config.live_search.link.label = I18n::t(i18n_scope+".index.search")   ;rescue;end
      begin;config.search.link.label = I18n::t(i18n_scope+".index.search")        ;rescue;end
      begin;config.show.link.label = I18n::t(i18n_scope+".index.show_link")       ;rescue;end
      begin;config.update.link.label = I18n::t(i18n_scope+".index.update_link")   ;rescue;end
      begin;config.delete.link.label = I18n::t(i18n_scope+".index.destroy_link")  ;rescue;end
      config.internationalization_prefix = i18n_scope;
      begin;config.has_sidebar = false                                            ;rescue;end
      begin;config.create.link.label = I18n::t(i18n_scope+".index.create")        ;rescue;end
      self.active_scaffold_list_columns(config, i18n_scope+".index.columns", columns)
      config.row_mark_actions_list = row_mark_actions_list
    end

    def active_scaffold_list_columns(config, i18n_scope, columns)
      columns.each do |column| 
        unless column == :row_mark
          config.columns << column unless config.columns[column]
          config.columns[column].label = I18n::t(i18n_scope+"."+column.to_s) 
        end
      end
      config.list.columns = columns
    end

  end
end

module Scaffoldapp
  class << self

    def active_scaffold(config, i18n_scope, options={})

      config.internationalization_prefix = i18n_scope;

      # LIVE SEARCH
      config.actions.swap :search, :live_search
      config.list.always_show_search = true

      # MAIN LABELS
      config.label = I18n::t(i18n_scope+".create.title")
      config.list.label = I18n::t(i18n_scope+".index.title")
      config.live_search.link.label = I18n::t(i18n_scope+".index.search")

      # LIST
      if value = options[:list]
        self.active_scaffold_list_columns(config, i18n_scope+".index.columns", value)
      end

      # CREATE
      if value = options[:create]
        config.create.link.page = true
        config.create.columns = value
        config.create.link.label = I18n::t(i18n_scope+".index.create")
      else
        config.actions.exclude :create
      end

      # SHOW
      if value = options[:show]
        config.show.link.page = true
        config.show.columns = value
        config.action_links.add 'show', :type => :record, :page => true,
                                        :label => I18n::t(i18n_scope+".index.show_link")
      else
        config.actions.exclude :show
      end

      # EDIT / UPDATE
      if value = options[:edit]
        config.update.link.page = true
        config.update.columns = value.empty? ? options[:create] : value
        config.action_links.add 'edit', :type => :record, :page => true,
                                        :label => I18n::t(i18n_scope+".index.update_link")
      else
        config.actions.exclude :edit
      end

      # DELETE
      config.delete.link.page = true
      config.action_links.add 'delete', :type => :record, :page => true,
                                        :label => I18n::t(i18n_scope+".index.destroy_link")

      # ROW MARK
      config.row_mark_actions_list = options[:row_mark] if value = options[:row_mark]
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

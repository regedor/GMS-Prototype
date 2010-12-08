module Scaffoldapp
  class << self

    def active_scaffold(config, i18n_scope, options={})

      config.internationalization_prefix = i18n_scope;

      # LIVE SEARCH
      config.actions.swap :search, :live_search
      config.list.always_show_search = true

      # MAIN LABELS
      config.label                  = I18n::t(i18n_scope+".create.title")
      config.list.label             = I18n::t(i18n_scope+".index.title")
      config.live_search.link.label = I18n::t(i18n_scope+".index.search")

      # ROW MARK
      if (value = options[:actions_list]) && !value.empty?
        options[:list].unshift :row_mark 
        config.row_mark_actions_list = value 
      else
        config.row_mark_actions_list = nil
      end

      # LIST
      if value = options[:list]
        self.active_scaffold_list_columns(config, i18n_scope + ".index.columns", value)
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
        config.show.columns = value
        config.action_links.add 'show', :type => :record, :page => true,
                                        :label => I18n::t(i18n_scope+".index.show_link")
      else
        config.actions.exclude :show
      end

      # EDIT / UPDATE
      if value = options[:edit]
        config.update.columns = value.empty? ? options[:create] : value
        config.action_links.add 'edit', :type => :record, :page => true,
                                        :label => I18n::t(i18n_scope+".index.update_link")
      else
        config.actions.exclude :update
      end

      # DELETE
      unless false == options[:delete]
        config.action_links.add 'delete', :type => :record, :page => true, :crud_type => :delete,
                                           :label => I18n::t(i18n_scope+".index.destroy_link")
      else
        config.actions.exclude :delete
      end
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

module ActiveScaffold
  module Config
    class Core
      cattr_accessor :row_mark_actions_list
      cattr_accessor :internationalization_prefix
    end
  end
  module Helpers
    module ViewHelpers
      def active_scaffold_includes(*args)
        frontend = args.first.is_a?(Symbol) ? args.shift : :default
        options = args.first.is_a?(Hash) ? args.shift : {}
        js = javascript_include_tag(*active_scaffold_javascripts(frontend).push(options))

        css = stylesheet_link_tag(*active_scaffold_stylesheets(frontend).push(options))
        options[:cache] += '_ie' if options[:cache].is_a? String
        options[:concat] += '_ie' if options[:concat].is_a? String
        ie_css = stylesheet_link_tag(*active_scaffold_ie_stylesheets(frontend).push(options))

        # ScaffoldAppDeveloper: added "" in the beginning to prevent escape.
        "" + js + "\n" + css + "\n<!--[if IE]>" + ie_css + "<![endif]-->\n"
      end
    end
  end
end


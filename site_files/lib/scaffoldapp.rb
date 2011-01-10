module Scaffoldapp
  class << self

    def active_scaffold(config, i18n_scope, options={})

      config.internationalization_prefix = i18n_scope;

      # LIVE SEARCH
      config.actions.exclude :search
      config.actions << :live_search
      config.list.always_show_search = true

      # MAIN LABELS
      config.label             = I18n::t(i18n_scope+".create.title")
      config.list.label        = I18n::t(i18n_scope+".index.title")

      # ROW MARK
      if (value = options[:actions_list]) && !value.empty?
        config.actions << :list_action
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
        config.action_links.add 'show', :type => :member, :page => true,
                                        :label => I18n::t(i18n_scope+".index.show_link")
      else
        config.actions.exclude :show
      end

      # EDIT / UPDATE
      if value = options[:edit]
        config.update.columns = value.empty? ? options[:create] : value
        config.action_links.add 'edit', :type => :member, :page => true,
                                        :label => I18n::t(i18n_scope+".index.update_link")
      else
        config.actions.exclude :update
      end

      # DELETE
      unless false == options[:delete]
        config.action_links.add 'delete', :type => :member, :page => true, :crud_type => :delete,
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

#TODO: Add list_action to routes automatically
#module ActionController
#  module Resources
#    class Resource
      #ACTIVE_SCAFFOLD_ROUTING[:collection][:list_action] = :post
      #ACTIVE_SCAFFOLD_ROUTING = {
      #  :collection => {:show_search => :get, :edit_associated => :get, :list => :get, :new_existing => :get, :add_existing => :post, :render_field => :get, :list_action => :post},
      #  :member => {:row => :get, :nested => :get, :edit_associated => :get, :add_association => :get, :update_column => :post, :destroy_existing => :delete, :render_field => :get, :delete => :get}
      #}
      #def options_with_active_scaffold
      #  raise self
      #  @options[:collection] ||= {}
      #  @options[:collection].merge! :lalala => :get
        #@options[:member] ||= {}
        #@options[:member].merge! ACTIVE_SCAFFOLD_ROUTING[:member]
      #end
    #end
  #end
#end

module ActiveScaffold

  module Config
    class Core
      cattr_accessor :row_mark_actions_list
      cattr_accessor :internationalization_prefix
    end
  end

  module Config
    class ListAction < Base
      self.crud_type = :read

      def initialize(core_config)
        @core = core_config

        # start with the ActionLink defined globally
        @link = self.class.link.clone
      end

      # global level configuration
      # --------------------------

      # the ActionLink for this action
      cattr_accessor :link
      @@link = ActiveScaffold::DataStructures::ActionLink.new('list_action', :crud_type => :read, :method => :list_action)

      # instance-level configuration
      # ----------------------------

      # the ActionLink for this action
      attr_accessor :link
    end
  end

  module Actions
    module ListAction
      def self.included(base)
        base.before_filter :list_action_authorized_filter, :only => :list_action
      end

      def list_action
        if !params[:ids].nil?
          ids = params[:ids].split('&')
          if !ids.empty? && active_scaffold_config.model.send(params[:actions], ids)
            list
            return
          end
        end
        head 500
      end

      protected
      # The default security delegates to ActiveRecordPermissions.
      # You may override the method to customize.
      def action_authorized?
        authorized_for?(:action => :update)
      end

      private
      def list_action_authorized_filter
        #link = active_scaffold_config.list_action.link || active_scaffold_config.list_action.class.link
        #raise ActiveScaffold::ActionNotAllowed unless self.send(link.security_method)
        raise ActiveScaffold::ActionNotAllowed unless authorized_for?(:action => :read)
      end
    end
  end
end


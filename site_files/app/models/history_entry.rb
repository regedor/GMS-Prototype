class HistoryEntry < ActiveRecord::Base

  # ==========================================================================
  # Modules
  # ==========================================================================

  module Historicable
    def self.included(base)
      base.send :has_many,      :history_entries, :as => :historicable
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
      base.send :before_update, :create_history_entry!
      base.send :after_create,  :create_first_history_entry!
    end

    module ClassMethods
    end

    module InstanceMethods
        # validates when a history entry should be created
        # this method will be used in before update
        # In some cases should be overriden in model
        def create_history_entry?
          true
        end
       
        def create_history_entry!
          return unless create_history_entry?
          message  =  self.to_label
          message += "has been altered"
          history_entry = HistoryEntry.create :historicable => self,
                                              :user_id      => (current_user && current_user.id or 1), 
                                              :message      => message,
                                              :xml_hash     => self.to_xml
        end

        def create_first_history_entry!
          message  =  self.to_label
          message += "has been altered"
          history_entry = HistoryEntry.create :historicable => self,
                                              :user_id      => (current_user && current_user.id or 1), 
                                              :message      => message,
                                              :xml_hash     => self.to_xml
        end

        def historicable_name
          to_label || name || to_s
        end

        def history_entries_list
          (history_entries[1..-1] || []).reverse
        end

       def is_historicable?
         true
       end

      end
  end


  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  belongs_to :historicable, :polymorphic => true 


  # ==========================================================================
  # Validations
  # ==========================================================================
  

  # ==========================================================================
  # Extra defnitions
  # ==========================================================================

  attr_accessible :historicable, :historicable_deleted, :message, :user_id, :xml_hash


  # ==========================================================================
  # Instance Methods
  # ==========================================================================
  
  def revert!
    hash = Hash.from_xml(self.xml_hash)
    self.historicable.attributes = hash[self.historicable_type.downcase]
    self.historicable.save
  end  
  
  def historicable_preview
    hash = Hash.from_xml(self.xml_hash)
    self.historicable_type.constantize.new hash[self.historicable_type.downcase]
  end  

 
  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self

  end

end

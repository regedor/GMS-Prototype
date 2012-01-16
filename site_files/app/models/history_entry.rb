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
          message += " has been altered"
          history_entry = HistoryEntry.create :historicable => self,
                                              :user_id      => (current_user && current_user.id or 1), 
                                              :message      => message,
                                              :xml_hash     => self.to_xml
        end

        def create_first_history_entry!
          message  =  self.to_label
          message += " has been altered"
          history_entry = HistoryEntry.create :historicable => self,
                                              :user_id      => (current_user && current_user.id or 1), 
                                              :message      => message,
                                              :xml_hash     => self.to_xml
        end


        def history_entries_list
          history_entries.reverse
        end

       def historicable?
         true
       end

      end
  end


  # ==========================================================================
  # Relationships
  # ==========================================================================
  
  belongs_to :historicable, :polymorphic => true 
  belongs_to :user


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


  def user_name
    user.nickname_or_first_and_last_name
  end
  
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

    #Returns the username of the user which made the action
    def get_name_and_type(id)
      if DeletedUser.find_by_id(id)
        return {:name => DeletedUser.find_by_id(id).nickname_or_first_and_last_name, :type => "deleted_user"   }
      elsif User.find_by_id(id)
        return {:name => User.find_by_id(id).nickname_or_first_and_last_name,        :type => "user"           }
      else
        return {:name => I18n::t("admin.deleted_users.index.deleted_user"),          :type => "destroyed_user" }
      end
    end
    
  end

end

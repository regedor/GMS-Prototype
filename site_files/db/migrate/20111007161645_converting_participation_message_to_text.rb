class ConvertingParticipationMessageToText < ActiveRecord::Migration
  def self.up
    change_column :events, :participation_message, :text
  end

  def self.down
    change_column :events, :participation_message, :string
  end
end

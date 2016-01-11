class ChangeLogEntryModelIdToInstanceId < ActiveRecord::Migration
  def self.up
    rename_column :log_entries, :object_id, :instance_id
  end

  def self.down
    rename_column :log_entries, :instance_id, :object_id
  end
end

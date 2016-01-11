class ChangeLogEntryModelToModelNameAndAttributeToAttributeName < ActiveRecord::Migration
  def self.up
    rename_column :log_entries, :model, :model_name
    rename_column :log_entries, :attribute, :attribute_name
  end

  def self.down
    rename_column :log_entries, :attribute_name, :attribute
    rename_column :log_entries, :model_name, :model
  end
end

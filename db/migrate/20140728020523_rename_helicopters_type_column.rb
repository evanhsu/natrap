class RenameHelicoptersTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column :helicopters, :type, :type_class
  end

  def self.down
    rename_column :helicopters, :type_class, :type
  end
end

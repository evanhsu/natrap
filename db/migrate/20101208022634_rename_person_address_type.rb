class RenamePersonAddressType < ActiveRecord::Migration
  def self.up
    rename_column :person_addresses, :type, :address_type
  end

  def self.down
    rename_column :person_addresses, :address_type, :type
  end
end

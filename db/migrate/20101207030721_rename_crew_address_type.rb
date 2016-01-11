class RenameCrewAddressType < ActiveRecord::Migration
  def self.up
    rename_column(:crew_addresses, :type, :address_type)
  end

  def self.down
    rename_column(:crew_addresses, :address_type, :type)
  end
end

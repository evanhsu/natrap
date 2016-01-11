class AddNotifyToPersonAddresses < ActiveRecord::Migration
  def self.up
    add_column :person_addresses, :notify, :boolean
  end

  def self.down
    remove_column :person_addresses, :notify
  end
end

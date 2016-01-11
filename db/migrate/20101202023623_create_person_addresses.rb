class CreatePersonAddresses < ActiveRecord::Migration
  def self.up
    create_table :person_addresses do |t|
      t.integer :person_id
      t.string :type
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :person_addresses
  end
end

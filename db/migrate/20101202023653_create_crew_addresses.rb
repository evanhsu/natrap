class CreateCrewAddresses < ActiveRecord::Migration
  def self.up
    create_table :crew_addresses do |t|
      t.integer :crew_id
      t.string :type
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :crew_addresses
  end
end

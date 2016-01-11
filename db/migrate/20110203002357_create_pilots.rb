class CreatePilots < ActiveRecord::Migration
  def self.up
    create_table :pilots do |t|
      t.integer :person_id
      t.string :vendor

      t.timestamps
    end
  end

  def self.down
    drop_table :pilots
  end
end

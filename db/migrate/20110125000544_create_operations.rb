class CreateOperations < ActiveRecord::Migration
  def self.up
    create_table :operations do |t|
      t.integer :incident_id
      t.string :aircraft_type_id
      t.string :aircraft_tailnumber
      t.integer :spotter_id
      t.integer :pilot_id
      t.string :weather
      t.integer :height
      t.integer :canopy_opening
      t.date :date
      t.string :location
      t.string :operation_type
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :operations
  end
end

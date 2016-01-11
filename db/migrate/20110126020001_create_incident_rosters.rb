class CreateIncidentRosters < ActiveRecord::Migration
  def self.up
    create_table :incident_rosters do |t|
      t.integer :incident_id
      t.string :role
      t.string :qt
      t.date :start_date
      t.date :end_date
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :incident_rosters
  end
end

class ChangeOperationIncidentIdToIncidentNumber < ActiveRecord::Migration
  def self.up
    remove_column :operations, :incident_id
    change_table :operations do |t|
      t.string :incident_number
    end
  end

  def self.down
    change_table :operations do |t|
      t.integer :incident_id
    end
    remove_column :operations, :incident_number
  end
end

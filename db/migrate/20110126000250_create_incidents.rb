class CreateIncidents < ActiveRecord::Migration
  def self.up
    create_table :incidents do |t|
      t.string :number
      t.date :date
      t.string :event_type
      t.string :name
      t.string :charge_code
      t.string :override
      t.integer :acres
      t.string :fuel_models
      t.text :description
      t.string :g_cal_event_url

      t.timestamps
    end
  end

  def self.down
    drop_table :incidents
  end
end

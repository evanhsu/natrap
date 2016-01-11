class CreateHelicopters < ActiveRecord::Migration
  def self.up
    create_table :helicopters do |t|
      t.string :tailnumber
      t.string :model
      t.integer :type
      t.string :contractType
      t.float :flightRate
      t.float :dailyAvailabilityRate
      t.float :pilotExtStandbyRate
      t.float :driverExtStandbyRate
      t.float :mechanicExtStandbyRate
      t.float :serviceTruckMileageRate
      t.string :hmgb

      t.timestamps
    end
  end

  def self.down
    drop_table :helicopters
  end
end

class CreateCostSheets < ActiveRecord::Migration
  def self.up
    create_table :cost_sheets do |t|
      t.date :date
      t.integer :helicopterId
      t.integer :helibaseId
      t.string :chargeCode
      t.string :override
      t.string :incidentNumber
      t.float :dailyAvailabilityRate
      t.float :pilotExtStandbyRate
      t.float :driverExtStandbyRate
      t.float :mechanicExtStandbyRate
      t.float :serviceTruckMileageRate
      t.string :hmgb
      t.float :dailyAvailabilityQty
      t.float :pilotExtStandbyQty
      t.float :driverExtStandbyQty
      t.float :mechanicExtStandbyQty
      t.float :serviceTruckMileageQty
      t.float :dailyAvailabilityTotal
      t.float :pilotExtStandbyTotal
      t.float :driverExtStandbyTotal
      t.float :mechanicExtStandbyTotal
      t.float :serviceTruckMileageTotal
      t.float :grandTotal
      t.string :additionalCostDesc
      t.float :additionalCostTotal
      t.integer :numPilots
      t.integer :numDrivers
      t.integer :numMechanics
      t.integer :pax
      t.integer :waterGallons
      t.integer :cargoLbs
      t.integer :retardantGallons
      t.integer :foamGallons
      t.float :acresTreated
      t.integer :psdBalls
      t.integer :gelGallons

      t.timestamps
    end
  end

  def self.down
    drop_table :cost_sheets
  end
end

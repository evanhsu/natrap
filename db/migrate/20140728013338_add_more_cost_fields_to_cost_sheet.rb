class AddMoreCostFieldsToCostSheet < ActiveRecord::Migration
  def self.up
    change_table :cost_sheets do |t|
      t.float :flight_hour_rate
      t.float :flight_hour_qty
      t.float :flight_hour_total
      t.integer :num_ron_people
      t.float :ron_rate
      t.float :ron_total

    end
  end

  def self.down
    remove_column(:cost_sheets,:flight_hour_rate,:flight_hour_qty,:flight_hour_total,:num_ron_people,:ron_rate,:ron_total)
  end
end

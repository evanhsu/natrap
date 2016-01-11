class CreateSpots < ActiveRecord::Migration
  def self.up
    create_table :spots do |t|
      t.integer :operation_id
      t.integer :rappel_spotter_id
      t.string :comments
      t.timestamps
    end
    change_table :operations do |t|
      t.remove :rappel_spotter_id
    end
  end

  def self.down
    change_table :operations do |t|
      t.integer :rappel_spotter_id
    end
    drop_table :spots
  end
end

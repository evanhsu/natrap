class CreateHelibases < ActiveRecord::Migration
  def self.up
    create_table :helibases do |t|
      t.string :name
      t.string :city
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end

  def self.down
    drop_table :helibases
  end
end

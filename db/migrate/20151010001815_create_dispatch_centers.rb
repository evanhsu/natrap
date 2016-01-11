class CreateDispatchCenters < ActiveRecord::Migration
  def change
    create_table :dispatch_centers do |t|
      t.string :name
      t.string :abbreviation
      t.string :callsign
      t.string :phone1
      t.string :phone2
      t.string :phone24
      t.string :fax
      t.string :location
      t.string :fscoverage
      t.string :blmcoverage
      t.string :parkcoverage
      t.string :email

      t.timestamps
    end
  end
end

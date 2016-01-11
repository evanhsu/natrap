class ChangeTrainingFacilityAddressFormatToSingleTextField < ActiveRecord::Migration
  def self.up
    change_table :training_facilities do |t|
      t.string :address
      t.remove :street1
      t.remove :street2
      t.remove :city
      t.remove :state
      t.remove :zip
    end
  end

  def self.down
    change_table :training_facilities do |t|
      t.string :zip
      t.string :state
      t.string :city
      t.string :street2
      t.string :street1
      t.remove :address
    end
  end
end

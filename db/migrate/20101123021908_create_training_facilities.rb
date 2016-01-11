class CreateTrainingFacilities < ActiveRecord::Migration
  def self.up
    create_table :training_facilities do |t|
      t.string :name
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :training_facilities
  end
end

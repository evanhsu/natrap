class AddFieldsToHelibases < ActiveRecord::Migration
  def change
    change_table :helibases do |t|
        t.rename :latitude, :lat_degrees
        t.rename :longitude, :lon_degrees

        t.integer  :crew_id
        t.string   :street
        #t.string  :city #Already exists
        t.string   :state
        t.string   :zip
        t.string   :main_phone
        t.string   :fax
        t.string   :airport_identifier
        t.string   :elevation
        #t.integer :lat_degrees
        t.float    :lat_minutes
        #t.integer :lon_degrees
        t.float    :lon_minutes
        t.string   :nearest_airport_name
        t.string   :nearest_airport_identifier
        t.string   :nearest_airport_elevation
        t.string   :department1_title
        t.string   :department1_contact_name
        t.string   :department1_phone
        t.string   :department2_title
        t.string   :department2_contact_name
        t.string   :department2_phone
        t.string   :department3_title
        t.string   :department3_contact_name
        t.string   :department3_phone
        t.string   :base_manager_name
        t.string   :base_manager_phone
        t.string   :airport_name
    end
  end
end

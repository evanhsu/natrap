class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
        t.string   :name
        t.string   :phone
        t.string   :street1
        t.string   :street2
        t.string   :city
        t.string   :state
        t.string   :zip
        t.integer  :crew_id
        t.timestamps
    end
  end
end

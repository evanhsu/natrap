class CreateFrequencies < ActiveRecord::Migration
  def change
    create_table :frequencies do |t|
        t.integer  :frequency_group_id
        t.integer  :channel
        t.string   :name
        t.string   :rx
        t.string   :rx_tone
        t.string   :tx
        t.string   :tx_tone
        t.string   :band
        t.string   :repeater_location
        t.string   :coverage_area
        t.string   :full_name
        t.timestamps
    end
  end
end

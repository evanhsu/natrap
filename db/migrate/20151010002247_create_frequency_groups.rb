class CreateFrequencyGroups < ActiveRecord::Migration
  def change
    create_table :frequency_groups do |t|
      t.string :name
      t.integer :dispatchcenter_id
      t.string :group_number
      t.integer :crew_id
      t.integer :dandy_id

      t.timestamps
    end
  end
end

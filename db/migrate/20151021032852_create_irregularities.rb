class CreateIrregularities < ActiveRecord::Migration
  def change
    create_table :irregularities do |t|
      t.date :date
      t.string :author
      t.string :fire_number
      t.string :fire_name
      t.string :tailnumber
      t.integer :operation_id
      t.string :narrative

      t.timestamps
    end
  end
end

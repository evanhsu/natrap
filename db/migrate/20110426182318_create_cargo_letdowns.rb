class CreateCargoLetdowns < ActiveRecord::Migration
  def self.up
    create_table :cargo_letdowns do |t|
      t.integer :operation_id
      t.string :letdown_line_number
      t.timestamps
    end
  end

  def self.down
    drop_table :cargo_letdowns
  end
end

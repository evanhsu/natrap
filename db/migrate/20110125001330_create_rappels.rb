class CreateRappels < ActiveRecord::Migration
  def self.up
    create_table :rappels do |t|
      t.integer :operation_id
      t.integer :person_id
      t.string :door
      t.integer :stick
      t.string :rope_end
      t.boolean :knot
      t.boolean :eto
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :rappels
  end
end

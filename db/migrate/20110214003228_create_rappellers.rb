class CreateRappellers < ActiveRecord::Migration
  def self.up
    create_table :rappellers do |t|
      t.integer :person_id
      t.integer :operational_offset
      t.integer :proficiency_offset
      t.integer :rookie_year
      t.timestamps
    end
  end

  def self.down
    drop_table :rappellers
  end
end

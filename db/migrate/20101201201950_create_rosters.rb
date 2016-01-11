class CreateRosters < ActiveRecord::Migration
  def self.up
    create_table :rosters do |t|
      t.integer :person_id
      t.integer :crew_id
      t.string :year

      t.timestamps
    end
  end

  def self.down
    drop_table :rosters
  end
end

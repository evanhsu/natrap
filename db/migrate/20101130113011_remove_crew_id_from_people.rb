class RemoveCrewIdFromPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.remove :crew_id
    end
  end

  def self.down
    change_table :people do |t|
      t.integer :crew_id
    end
  end
end

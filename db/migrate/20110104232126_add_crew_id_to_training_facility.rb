class AddCrewIdToTrainingFacility < ActiveRecord::Migration
  def self.up
    change_table :training_facilities do |t|
      t.integer :crew_id
    end
  end

  def self.down
    change_table :training_facilities do |t|
      t.remove :crew_id
    end
  end
end

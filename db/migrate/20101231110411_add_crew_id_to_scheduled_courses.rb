class AddCrewIdToScheduledCourses < ActiveRecord::Migration
  def self.up
    change_table :scheduled_courses do |t|
      t.integer :crew_id
    end
  end

  def self.down
    change_table :scheduled_courses do |t|
      t.remove :crew_id
    end
  end
end
class CreateScheduledCourses < ActiveRecord::Migration
  def self.up
    create_table :scheduled_courses do |t|
      t.date :date_start
      t.date :date_end
      t.string :location
      t.integer :training_facility_id
      t.string :name
      t.string :g_cal_event_url
      t.text :comments
      t.timestamps
    end
  end

  def self.down
    drop_table :scheduled_courses
  end
end

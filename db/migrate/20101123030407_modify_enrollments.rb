class ModifyEnrollments < ActiveRecord::Migration
  def self.up
    change_table :enrollments do |t|
      t.string :course_name
      t.remove :certificate_received
      t.date :certificate_received
    end
  end

  def self.down
    change_table :enrollments do |t|
      t.remove :certificate_received
      t.boolean :certificate_received
      t.remove :course_name
    end
  end
end

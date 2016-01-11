class CreateEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.integer :person_id
      t.integer :scheduled_course_id
      t.string :status
      t.boolean :certificate_received
      t.float :cost_tuition
      t.float :cost_wages
      t.boolean :prework_received
      t.string :payment_method
      t.string :charge_code
      t.string :override
      t.boolean :travel_paid
      t.float :cost_travel
      t.float :cost_misc
      t.timestamps
    end
  end

  def self.down
    drop_table :enrollments
  end
end

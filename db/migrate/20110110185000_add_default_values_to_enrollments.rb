class AddDefaultValuesToEnrollments < ActiveRecord::Migration
  def self.up
    change_table :enrollments do |t|
      t.change :status, :string, :default => 'nominated'
      t.change :cost_tuition, :float, :default => 0
      t.change :cost_wages, :float, :default => 0
      t.change :cost_travel, :float, :default => 0
      t.change :cost_misc, :float, :default => 0
      t.change :prework_received, :boolean, :default => false
      t.change :travel_paid, :boolean, :default => false
    end
  end

  def self.down
    change_table :enrollments do |t|
      t.change :travel_paid, :boolean, :default => nil
      t.change :prework_received, :boolean, :default => nil
      t.change :cost_misc, :float, :default => nil
      t.change :cost_travel, :float, :default => nil
      t.change :cost_wages, :float, :default => nil
      t.change :cost_tuition, :float, :default => nil
      t.change :status, :string, :default => nil
    end
  end
end

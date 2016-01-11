class AddAccountCrewToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.integer :account_crew_id
    end
  end

  def self.down
    change_table :people do |t|
      t.remove :account_crew_id
    end
  end
end

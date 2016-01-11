class ModifyRoster < ActiveRecord::Migration
  def self.up
    change_table :rosters do |t|
      t.remove  :person_id
      t.remove  :bio
      t.remove  :role
    end
  end

  def self.down
    change_table :rosters do |t|
      t.string  :role
      t.string  :bio
      t.integer :person_id
    end
  end
end

class CreateRosteredPeople < ActiveRecord::Migration
  def self.up
    create_table :rostered_people do |t|
      t.integer     :roster_id
      t.string      :person_id
      t.string      :role
      t.string      :bio
      
      t.timestamps
    end
  end

  def self.down
    drop_table :rostered_people
  end
end

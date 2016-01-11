class CreateTrainingPriorities < ActiveRecord::Migration
  def self.up
    create_table :training_priorities do |t|
      t.integer :priority
      t.string :name
      t.integer :crew_id
      t.string :qualification
      t.boolean :available

      t.timestamps
    end
  end

  def self.down
    drop_table :training_priorities
  end
end

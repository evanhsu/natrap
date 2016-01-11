class CreateLogEntries < ActiveRecord::Migration
  def self.up
    create_table :log_entries do |t|
      t.integer :person_id
      t.integer :object_id
      t.string  :model
      t.string  :action
      t.string  :attribute
      t.string  :old_value
      t.string  :new_value
      t.string  :comments
      t.timestamps
    end
  end

  def self.down
    drop_table :log_entries
  end
end

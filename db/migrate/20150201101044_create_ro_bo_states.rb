class CreateRoBoStates < ActiveRecord::Migration
  def self.up
    create_table :ro_bo_states do |t|
#      t.integer :id
      t.integer :userId
      t.string :username

      t.timestamps
    end
  end

  def self.down
    drop_table :ro_bo_states
  end
end

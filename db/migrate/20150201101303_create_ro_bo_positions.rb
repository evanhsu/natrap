class CreateRoBoPositions < ActiveRecord::Migration
  def self.up
    create_table :ro_bo_positions do |t|
#      t.integer :id
      t.integer :roBoStateId
      t.integer :personId
      t.string :role
      t.string :rank
      t.integer :cellIndex
      t.string :listId
      t.integer :row
      t.integer :col

      t.timestamps
    end
  end

  def self.down
    drop_table :ro_bo_positions
  end
end

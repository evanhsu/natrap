class AddCreatorIdToOperations < ActiveRecord::Migration
  def self.up
    add_column :operations, :creator_id, :integer
  end

  def self.down
    remove_column :operations, :creator_id
  end
end

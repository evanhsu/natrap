class RemoveHelibaseIdFromCostSheet < ActiveRecord::Migration
  def self.up
    remove_column(:cost_sheets,:helibaseId)
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end

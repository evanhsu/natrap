class RenameCostSheetHelicopterIdCol < ActiveRecord::Migration
  def self.up
    rename_column :cost_sheets, :helicopterId, :helicopter_id
  end

  def self.down
    rename_column :cost_sheets, :helicopter_id, :helicopterId
  end
end

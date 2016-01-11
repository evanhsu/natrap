class ChangeOperationSpotterIdToRappelSpotterId < ActiveRecord::Migration
  def self.up
    rename_column :operations, :spotter_id, :rappel_spotter_id
  end

  def self.down
    rename_column :operations, :rappel_spotter_id, :spotter_id
  end
end

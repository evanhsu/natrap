class ChangeChangePersonIdToChangedPersonId < ActiveRecord::Migration
  def self.up
    rename_column :ro_bo_states, :change_person_id, :changed_person_id
  end

  def self.down
    rename_column :ro_bo_states, :changed_person_id, :change_person_id
  end
end

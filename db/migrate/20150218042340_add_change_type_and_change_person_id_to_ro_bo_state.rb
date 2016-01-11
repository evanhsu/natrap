class AddChangeTypeAndChangePersonIdToRoBoState < ActiveRecord::Migration
  def self.up
    add_column :ro_bo_states, :change_type, :string
    add_column :ro_bo_states, :change_person_id, :integer
  end

  def self.down
    remove_column :ro_bo_states, :change_person_id
    remove_column :ro_bo_states, :change_type
  end
end

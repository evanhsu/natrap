class AddCrewIdToRoBoStates < ActiveRecord::Migration
  def self.up
    add_column :ro_bo_states, :crew_id, :integer
    change_table :ro_bo_states do |t|
      t.rename :userId, :user_id
    end
  end

  def self.down
    change_table :ro_bo_states do |t|
      t.rename :user_id, :userId
      t.remove :crew_id
    end


  end
end

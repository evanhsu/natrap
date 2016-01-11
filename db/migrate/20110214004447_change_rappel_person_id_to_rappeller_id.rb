class ChangeRappelPersonIdToRappellerId < ActiveRecord::Migration
  def self.up
    rename_column :rappels, :person_id, :rappeller_id
  end

  def self.down
    rename_column :rappels, :rappeller_id, :person_id
  end
end

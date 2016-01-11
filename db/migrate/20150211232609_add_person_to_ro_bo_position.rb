class AddPersonToRoBoPosition < ActiveRecord::Migration
  def self.up
    add_column :ro_bo_positions, :person_name, :string
    add_column :ro_bo_positions, :person_quals, :string
    add_column :ro_bo_positions, :person_headshot_url, :string
  end

  def self.down
    remove_column :ro_bo_positions, :person_headshot_url
    remove_column :ro_bo_positions, :person_quals
    remove_column :ro_bo_positions, :person_name
  end
end

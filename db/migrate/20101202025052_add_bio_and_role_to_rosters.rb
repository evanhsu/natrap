class AddBioAndRoleToRosters < ActiveRecord::Migration
  def self.up
    change_table :rosters do |t|
      t.string :bio
      t.string :role
    end
  end

  def self.down
    change_table :rosters do |t|
      t.remove :role
      t.remove :bio
    end
  end
end

class CreateCrews < ActiveRecord::Migration
  def self.up
    create_table :crews do |t|
      t.string :name
      t.string :abbrev
      t.integer :region
      t.string :logo_filename

      t.timestamps
    end
  end

  def self.down
    drop_table :crews
  end
end

class AddHelibaseIdToHelicopter < ActiveRecord::Migration
  def self.up
    change_table :helicopters do |t|
      t.integer :helibase_id
    end
  end

  def self.down
    change_table :helicopters do |t|
      t.remove :helibase_id
    end
  end
end

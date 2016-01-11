class CreateCrewsDandies < ActiveRecord::Migration
  def change
    create_table :crews_dandies, id: false do |t|
        t.integer  :crew_id
        t.integer  :dandy_id
    end

    add_index :crews_dandies, :crew_id
    add_index :crews_dandies, :dandy_id
  end
end

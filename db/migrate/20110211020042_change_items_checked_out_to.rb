class ChangeItemsCheckedOutTo < ActiveRecord::Migration
  def self.up
    rename_column :items, :checked_out_to, :checked_out_to_id
  end

  def self.down
    rename_column :items, :checked_out_to_id, :checked_out_to
  end
end

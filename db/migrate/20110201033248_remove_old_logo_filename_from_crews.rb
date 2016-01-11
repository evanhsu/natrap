class RemoveOldLogoFilenameFromCrews < ActiveRecord::Migration
  def self.up
    change_table :crews do |t|
      t.remove  :logo_filename
    end
  end

  def self.down
    change_table :crews do |t|
      t.string  :logo_filename
    end
  end
end
class AddFieldsToRappels < ActiveRecord::Migration
  def self.up
    change_table :rappels do |t|
      t.string :rope_number
      t.string :descent_device_number
      t.string :purpose
    end
  end

  def self.down
    change_table :rappels do |t|
      t.remove :purpose
      t.remove :descent_device_number
      t.remove :rope_number
    end
  end
end

class AddConfirmationFieldsToRappels < ActiveRecord::Migration
  def self.up
    change_table :rappels do |t|
      t.boolean :confirmed
    end
  end

  def self.down
    change_table :rappels do |t|
      t.remove :confirmed
    end
  end
end

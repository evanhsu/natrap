class AddYearToCertificate < ActiveRecord::Migration
  def self.up
    change_table :certificates do |t|
      t.text :year
    end
  end

  def self.down
    change_table :certificates do |t|
      t.remove :year
    end
  end
end

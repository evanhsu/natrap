class AddAuthenticationToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.string :salt
      t.string :account_type
      t.datetime :last_login
      t.integer :crew_id
    end
  end

  def self.down
    change_table :people do |t|
      t.remove :crew_id
      t.remove :last_login
      t.remove :account_type
      t.remove :salt
    end
  end
end

class AddAuthorizationsToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.string :authorizations
    end
  end

  def self.down
    change_table :people do |t|
      t.remove :authorizations
    end
  end
end

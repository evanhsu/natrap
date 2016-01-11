class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :iqcs_num
      t.string :firstname
      t.string :lastname
      t.string :gender
      t.date :birthdate
      t.string :username
      t.string :password
      t.string :headshot_filename
      t.boolean :has_purchase_card
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end

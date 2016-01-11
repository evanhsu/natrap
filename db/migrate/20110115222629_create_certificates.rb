class CreateCertificates < ActiveRecord::Migration
  def self.up
    create_table :certificates do |t|
      t.string    :name
      t.integer   :person_id
      t.integer   :enrollment_id
      t.string    :filename
      t.timestamps
    end
  end

  def self.down
    drop_table :certificates
  end
end

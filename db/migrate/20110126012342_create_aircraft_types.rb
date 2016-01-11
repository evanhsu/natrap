class CreateAircraftTypes < ActiveRecord::Migration
  def self.up
    create_table :aircraft_types do |t|
      t.string :shortname
      t.string :fullname
      t.string :configuration
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :aircraft_types
  end
end

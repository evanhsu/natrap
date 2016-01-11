class AddPaperclipColumnsToCertificate < ActiveRecord::Migration
  def self.up
    change_table :certificates do |t|
      t.remove :filename
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
    end
  end

  def self.down
    change_table :certificates do |t|
      t.remove :image_updated_at
      t.remove :image_file_size
      t.remove :image_content_type
      t.remove :image_file_name
      t.string :filename
    end
  end

end

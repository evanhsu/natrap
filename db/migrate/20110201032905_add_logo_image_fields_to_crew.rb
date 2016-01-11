class AddLogoImageFieldsToCrew < ActiveRecord::Migration
  def self.up
    change_table :crews do |t|
      t.string    :logo_file_name
      t.string    :logo_content_type
      t.string    :logo_file_size
      t.datetime  :logo_updated_at
    end
  end

  def self.down
    change_table :crews do |t|
      t.remove  :logo_updated_at
      t.remove  :logo_file_size
      t.remove  :logo_content_type
      t.remove  :logo_file_name
    end
  end
end

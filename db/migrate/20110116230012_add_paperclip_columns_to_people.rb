class AddPaperclipColumnsToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.rename :headshot_filename, :headshot_file_name
      t.string :headshot_content_type
      t.string :headshot_file_size
      t.datetime :headshot_updated_at
    end
  end

  def self.down
    change_table :people do |t|
      t.remove :headshot_updated_at
      t.remove :headshot_file_size
      t.remove :headshot_content_type
      t.rename :headshot_file_name, :headshot_filename
    end
  end

end

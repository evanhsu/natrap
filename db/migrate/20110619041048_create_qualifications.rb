class CreateQualifications < ActiveRecord::Migration
  def self.up
    create_table :qualifications do |t|
      t.string :acronym
      t.boolean :trainee
      t.string :description
      t.date   :date_initiated
      t.date   :date_qualified
      t.string :document_file_name
      t.string :document_file_type
      t.integer :document_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :qualifications
  end
end

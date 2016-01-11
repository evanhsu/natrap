class AddDocumentCreatedAtToQualifications < ActiveRecord::Migration
  def self.up
    change_table :qualifications do |t|
      t.datetime :document_updated_at
    end
    rename_column :qualifications, :document_file_type, :document_content_type
  end

  def self.down
    rename_column :qualifications, :document_content_type, :document_file_type
    change_table :qualifications do |t|
      t.remove :document_updated_at
    end
  end
end

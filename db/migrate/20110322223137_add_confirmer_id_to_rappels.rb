class AddConfirmerIdToRappels < ActiveRecord::Migration
  def self.up
    add_column :rappels, :confirmer_id, :integer
  end

  def self.down
    remove_column :rappels, :confirmer_id
  end
end

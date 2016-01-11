class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string      :serial_number
      t.string      :type
      t.string      :category
      t.string      :color
      t.string      :size
      t.string      :description
      t.string      :condition
      t.string      :comments
      t.integer     :crew_id
      t.string      :status
      t.string      :use_offset
      t.date        :in_service_date
      t.date        :retired_date
      t.string      :retired_category
      t.string      :retired_reason
      t.decimal     :quantity
      t.decimal     :restock_trigger
      t.decimal     :restock_to_level
      t.text        :item_source
      t.integer     :checked_out_to
      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end

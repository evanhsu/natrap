class CreateRequisitions < ActiveRecord::Migration
  def change
    create_table :requisitions do |t|
	t.belongs_to :crew, index: true
	t.text :vendor_info
	t.text :description
	t.decimal :amount, precision:7, scale:2
	t.date :date
	t.text :cardholder
	t.text :comments
	t.attachment :attachment1
	t.attachment :attachment2
	t.attachment :attachment3
	t.text :modified_by
      t.timestamps
    end
  end
end

class CreateRequisitionLineItems < ActiveRecord::Migration
  def change
    create_table :requisition_line_items do |t|
      t.belongs_to :requisition, index: true
      t.text :s_number
      t.text :charge_code
      t.text :override
      t.decimal	:amount, precision:7, scale:2
      t.boolean :received, default: FALSE
      t.boolean :reconciled, default: FALSE
      t.text :comments
      t.timestamps
    end
  end
end

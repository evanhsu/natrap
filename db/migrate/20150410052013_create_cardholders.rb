class CreateCardholders < ActiveRecord::Migration
  def change
    create_table :cardholders do |t|
      t.belongs_to :crew, index: true
      t.text :name
      t.timestamps
    end
  end
end

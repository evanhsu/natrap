class AddCategoryToIrregularities < ActiveRecord::Migration
  def change
    change_table :irregularities do |t|
        t.string :category
    end
  end
end

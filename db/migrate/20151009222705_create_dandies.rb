class CreateDandies < ActiveRecord::Migration
  def change
    create_table :dandies do |t|

      t.timestamps
    end
  end
end

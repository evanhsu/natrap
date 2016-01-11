class CreateDandyStaticPages < ActiveRecord::Migration
  def change
    create_table :dandy_static_pages do |t|

      t.timestamps
    end
  end
end

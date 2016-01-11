class AddComplexityToIncidents < ActiveRecord::Migration
  def self.up
    change_table :incidents do |t|
      t.integer   :complexity
    end
  end

  def self.down
    change_table :incidents do |t|
      t.remove    :complexity
    end
  end
end

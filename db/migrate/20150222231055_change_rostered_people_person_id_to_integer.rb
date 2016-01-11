class ChangeRosteredPeoplePersonIdToInteger < ActiveRecord::Migration
  def change
    reversible do |dir|
        change_table :rostered_people do |table|
          dir.up    {table.change :person_id, 'integer USING CAST(person_id AS integer)' }
          dir.down  {table.change :person_id, :string  }
        end
    end
  end
end

class RoBoPosition < ActiveRecord::Base
  belongs_to :ro_bo_state, :foreign_key => "roBoStateId"
  belongs_to :person, :foreign_key => "personId"
  
end

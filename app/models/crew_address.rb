class CrewAddress < ActiveRecord::Base
  belongs_to :crew, :inverse_of => :address
  
  #validates :crew_id, :presence => true
end

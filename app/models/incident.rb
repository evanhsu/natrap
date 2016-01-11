class Incident < ActiveRecord::Base
  has_many :operations
  has_many :incident_rosters
  has_many :people, :through => :incident_rosters
end

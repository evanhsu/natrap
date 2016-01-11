class IncidentRoster < ActiveRecord::Base
  belongs_to :incident
  belongs_to :person
end

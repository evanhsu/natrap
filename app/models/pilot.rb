class Pilot < ActiveRecord::Base
  belongs_to :person
  has_many :operations

  validates :person_id, :presence => true
end

class RappelSpotter < ActiveRecord::Base
  belongs_to :person
  has_many :spots
  has_many :operations, :through => :spots

  before_create do
    self.id = self.person.id
  end
end

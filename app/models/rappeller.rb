class Rappeller < ActiveRecord::Base
  belongs_to :person
  has_many :rappels

  before_create do
    self.id = self.person.id
  end
end

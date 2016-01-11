class Helibase < ActiveRecord::Base
  has_many :helicopters
  has_many :cost_sheets, through: :helicopters
end

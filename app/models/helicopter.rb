class Helicopter < ActiveRecord::Base
  belongs_to :helibase
  has_many :cost_sheets
end

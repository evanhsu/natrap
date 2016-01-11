class CostSheet < ActiveRecord::Base
  belongs_to :helicopter

  validates :date, :charge_code, :presence => true
end

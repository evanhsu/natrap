class FrequencyGroup < ActiveRecord::Base
  has_many    :frequencies
  belongs_to  :dispatch_center
  belongs_to  :crew
  belongs_to  :dandy
  accepts_nested_attributes_for :frequencies
end

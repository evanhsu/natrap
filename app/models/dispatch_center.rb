class DispatchCenter < ActiveRecord::Base
  has_many :radio_groups
  has_many :frequencies, :through => :radio_groups
  
end

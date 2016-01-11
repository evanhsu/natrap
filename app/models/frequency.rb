class Frequency < ActiveRecord::Base
  belongs_to :frequency_group

  validates :repeater_location, :length => {:maximum => 45, :message => "Repeater location must be 45 characters or fewer"}
end

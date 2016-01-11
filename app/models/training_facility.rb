class TrainingFacility < ActiveRecord::Base
  has_many :scheduled_courses
  belongs_to :crew

  def address_one_line
    self.address.to_s.gsub('\n',', ')
  end

  def address_two_line
    self.address.to_s.gsub('\n','<br />')
  end
  
end

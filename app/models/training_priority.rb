class TrainingPriority < ActiveRecord::Base
  belongs_to :crew

  def activate
    self.available = true
  end

  def deactivate
    self.available = false
  end
  
end

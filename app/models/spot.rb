class Spot < ActiveRecord::Base
  belongs_to :spotter, :class_name => "RappelSpotter", :foreign_key => "rappel_spotter_id"
  belongs_to :operation
  belongs_to :confirmer, :class_name => "Person"
  
  validate :ensure_spotter_exists

  def ensure_spotter_exists
    unless RappelSpotter.find_by_id(self.rappel_spotter_id)
      self.errors.add :base, "Couldn't find this spotter in the system"
    end
  end

  def spotter_fullname
    self.spotter ? self.spotter.person.fullname : ""
  end

  def confirmed?
    !self.confirmer_id.blank?
  end

  def confirm(person)
    self.confirmer_id = person.id
  end

  def unconfirm
    self.confirmer_id = nil
  end

  def set_confirmation(person)
    if(self.spotter)
      if person.current_crew == self.spotter.person.current_or_most_recent_crew
        self.confirm(person)
      else
        self.unconfirm
      end
    end
  end

  def clear
    self.spotter = nil
    self.comments = ""
    self.unconfirm
  end

  def editable_by?(person)
    person.has_authorization?(Authorizations::EDIT_OPERATIONS) && (person.current_crew == self.spotter.person.current_or_most_recent_crew || (self.operation.nil? ? true : (person.current_crew == self.operation.crew)))
  end

  def position
    "spotter"
  end
end

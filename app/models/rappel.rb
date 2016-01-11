class Rappel < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :operation
  belongs_to :rappeller
  belongs_to :confirmer, :class_name => "Person"
  belongs_to :rope, :class_name => "RappelEquipment", :primary_key => "serial_number", :foreign_key => "rope_number"
  belongs_to :descent_device, :class_name => "RappelEquipment", :primary_key => "serial_number", :foreign_key => "descent_device_number"

  validates :rappeller, :presence => true
  #validate :validate_rope_type
  #validate :validate_descent_device_type

  #attr_protected :id, :confirmed, :confirmer_id #These attributes must be protected in the controller with STRONG PARAMS

  PURPOSES = ['operational','proficiency','initial_cert','re-cert']

  def validate_rope_type
    #if present, rope must be an item of the proper category
    unless self.rope_number.blank?
      if (rope = Item.find_by_serial_number(self.rope_number.upcase) and rope.category != RappelEquipment::ROPE)
        self.errors.add :base, "Expected #{self.rope_number} to be a rope, but it is in the system as a #{rope.category.downcase}."
      end
    end
  end

  def validate_descent_device_type
    #if present, descent_device must be an item of the proper category
    unless self.descent_device_number.blank?
      if (descent_device = Item.find_by_serial_number(self.descent_device_number.upcase) and
          descent_device.category != RappelEquipment::DESCENT_DEVICE)
        self.errors.add :base, "Expected #{self.descent_device_number} to be a descent device, but it is in the system as a #{descent_device.category.downcase}."
      end
    end
  end
  
  def rappeller_fullname
    if self.rappeller
      return self.rappeller.person.firstname + " " + self.rappeller.person.lastname
    end
  end

  def person_id=(id)
    self.rappeller = Rappeller.find_by_person_id(id)
  end

  def confirmed?
    !self.confirmer_id.nil?
  end

  def confirm(person)
    self.confirmer_id = person.id
  end

  def unconfirm
    self.confirmer_id = nil
  end

  def position
    "#{self.stick}_#{self.door}"
  end

  def editable_by?(person)
    person.has_authorization?(Authorizations::EDIT_OPERATIONS) && (person.current_crew == self.rappeller.person.current_or_most_recent_crew || person.current_crew == self.operation.crew)
  end

  def set_confirmation(person)
    if(self.rappeller)
      if person.current_crew == self.rappeller.person.current_or_most_recent_crew
        self.confirm(person)
      else
        self.unconfirm
      end
    end
  end
end

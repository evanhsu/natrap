class RappelEquipment < Item
  #This type of item utilizes the following special columns in the table:
  #  :serial_number
  #  :use_offset
  #  :status          ['in_service','retired','unavailable']
  #  :in_service_date
  #  :retired_date
  #  :retired_reason
  #  :retired_category  ['age','use','field_damage','other_damage']
  has_many :rappels
  
  SERIAL_NUMBER_FORMAT = /[a-zA-Z]{3,6}-[0-9]{3}/
  SERIAL_NUMBER_FORMAT_DESCRIPTION = "The serial number must be a group of letters, a hyphen, then a group of numbers (i.e. ABC-123)"

  RAPPEL_EQUIPMENT_STATUSES = ['in-service','retired','unavailable']
  RAPPEL_EQUIPMENT_RETIRED_CATEGORIES = ['age','use','field_damage','other_damage']

  ROPE = "rope"
  DESCENT_DEVICE = "descent_device"
  RAPPEL_HARNESS = "rappel_harness"
  LETDOWN_LINE = "letdown_line"

  CATEGORIES = [ROPE, DESCENT_DEVICE, RAPPEL_HARNESS, LETDOWN_LINE]

  validates :serial_number, 
    :presence => {:message => "Please enter a serial number for this piece of rappel equipment."},
    :format => {:with => SERIAL_NUMBER_FORMAT, :message => SERIAL_NUMBER_FORMAT_DESCRIPTION},
    :uniqueness => {:scope => :category, :message => "The serial number for item is already in use."}
  validates :status, 
    :inclusion => {:in => RAPPEL_EQUIPMENT_STATUSES,
                   :message => "Please specify the current status of this rappel equipment."}
  validates :retired_reason, :retired_category, :retired_date,
    :presence => {:message => "Please provide all retirement information for this item, or change its status.",
                  :if => "!self.status.nil? && (self.status.downcase == 'retired')"}
  validates :retired_category, 
    :inclusion => {:in => RAPPEL_EQUIPMENT_RETIRED_CATEGORIES,
                   :message => "The retirement category for this piece of rappel equipment is not valid.",
                   :if => "!self.status.nil? && (self.status.downcase == 'retired')"}
  validates :use_offset,
    :numericality => {:unless => "!self.category.blank? && (self.category.downcase == 'rope' or self.category.downcase == 'letdown_line')"},
    :format => {:with => /\ba\d+b\d+\Z/, :if => "!self.category.blank? && (self.category.downcase == 'rope' or self.category.downcase == 'letdown_line')"}
  before_validation :clear_retirement_info_if_not_retired
  before_validation :format_use_offset_if_needed
  after_initialize :set_default_values

  private
    def set_default_values
      return unless new_record?
      self.type = "RappelEquipment"
      self.status = "in-service" unless self.status
    end

    def clear_retirement_info_if_not_retired
      self.retired_date, self.retired_category, self.retired_reason = nil,nil,nil unless (!self.status.nil? && self.status.downcase == "retired")
    end

    def format_use_offset_if_needed
      if (self.use_offset.blank? or self.use_offset == 0)
        if (!self.category.nil? && (self.category.downcase == 'rope' or self.category.downcase == 'letdown_line'))
          self.use_offset = "a0b0"
        else
          self.use_offset = 0
        end
      end
    end

end

class AccountableItem < Item
  validates :serial_number,
    :presence => {:message => "You must enter a serial number for this item."},
    :uniqueness => {:scope => :category, :message => "The serial number you entered is already in use."}
  after_initialize :set_default_values


  private
  def set_default_values
    return unless new_record?
    self.type = "AccountableItem"
  end  
end

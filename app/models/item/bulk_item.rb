class BulkItem < Item
  #This type of item utilizes the following special columns in the table:
  #  :quantity
  #  :restock_trigger
  #  :restock_to_level
  validates :quantity, :restock_trigger, :restock_to_level, :numericality => {:message => "Quantities and restock levels must be numbers."}
  after_initialize :set_default_values




  private
  def set_default_values
    return unless new_record?
    self.type = "BulkItem"
    self.quantity = 0 unless self.quantity
    self.restock_to_level = 0 unless self.restock_to_level
    self.restock_trigger = 0 unless self.restock_trigger
  end
end

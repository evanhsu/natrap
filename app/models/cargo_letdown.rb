class CargoLetdown < ActiveRecord::Base
  belongs_to :operation
  belongs_to :letdown_line, :class_name => "RappelEquipment", :primary_key => "serial_number", :foreign_key => "letdown_line_number"
end

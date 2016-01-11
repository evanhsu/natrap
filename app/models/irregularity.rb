class Irregularity < ActiveRecord::Base
    attr_accessible :date, :author,:fire_number, :fire_name, :tailnumber, :operation_id, :narrative

end

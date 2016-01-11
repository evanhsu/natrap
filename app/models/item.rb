class CrewExistenceValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << "This item belongs to a non-existent crew." unless Crew.exists?(record.crew_id)
  end
end

class CheckedOutToValidator < ActiveModel::Validator
  def validate(record)
    if (!record.checked_out_to_id.blank?)
      record.errors[:base] << "This item is checked out to a non-existent person." unless Person.exists?(record.checked_out_to_id)
    end
  end
end

class Item < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with CrewExistenceValidator
  validates_with CheckedOutToValidator
  
  belongs_to :crew
  belongs_to :checked_out_to, :class_name => "Person", :foreign_key => "checked_out_to_id"

  validates :type, :presence => true
  validates :category, :presence => {:message => "Please specify a category for this item (i.e. sleeping bag, rope, etc)."}
  validates :crew_id, :presence => {:message => "This item must belong to a valid Crew."}

  #Must explicitly name subclasses as a workaround for a development-mode bug.
  if Rails.env.development?
    require_dependency "item/rappel_equipment.rb"
    require_dependency "item/accountable_item.rb"
    require_dependency "item/bulk_item.rb"
  end
end


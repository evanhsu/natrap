class PersonRosteredOnOneCrewPerYearValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    committed_people = Roster.find_all_by_year(Roster.find(record.roster_id).year).collect {|t| t.people.collect {|y| y.id}}.flatten
    record.errors[attribute] << 'cannot belong to more than one crew roster at a time.' if committed_people.include?(value)
  end
end

class PersonExistsValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    record.errors[attribute] << 'does not refer to an existing person.' if Person.find_all_by_id(value).blank?
  end
end

class RosteredPerson < ActiveRecord::Base
  belongs_to :roster
  belongs_to :person

  validates :person_id, :roster_id, :presence => true
  validates :person_id, :person_rostered_on_one_crew_per_year => true
  validates :person_id, :person_exists => true

  def rosters
    RosteredPerson.find_all_by_person_id(self.id).collect {|t| t.roster}
  end

  def self.find_rosters_by_person_id(person_id)
    RosteredPerson.find_all_by_person_id(person_id).collect {|t| t.roster}
  end
end

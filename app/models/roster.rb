class Roster < ActiveRecord::Base
  has_many :rostered_people, :dependent => :destroy
  has_many :people, :through => :rostered_people
  belongs_to :crew

  scope :year, lambda { |year| where(:year => year) }
  scope :current_year, where(:year => Time.now.year)

  validates_format_of :year, :with => /\A(19|20)([0-9]{2})\z/, :message => "Invalid roster year"
  validates_uniqueness_of :crew_id, :scope => :year

  def self.people_not_rostered_by_year(year)
    committed_people = Roster.find_all_by_year(year).collect {|t| t.people.collect {|y| y.id}}.flatten
    all_people = Person.all.collect {|t| t.id}
    available_people_ids = all_people - committed_people
    Person.find_all_by_id(available_people_ids)
  end
end

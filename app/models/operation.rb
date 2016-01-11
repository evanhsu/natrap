class Operation < ActiveRecord::Base
  belongs_to :incident, :primary_key => "number", :foreign_key => "incident_number"
  belongs_to :pilot
  belongs_to :aircraft_type
  belongs_to :creator, :class_name => "Person"
  has_many :rappels, :dependent => :destroy
  has_many :rappellers, :through => :rappels
  has_one :spot
  has_one :spotter, :through => :spot, :class_name => "RappelSpotter"
  has_many :cargo_letdowns
  has_many :letdown_lines, :through => :cargo_letdowns

  accepts_nested_attributes_for :rappels, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :spot, :allow_destroy => true

  validates :height, :presence => true
  validates :spot, :presence => true

  attr_accessor :pilot_fullname, :crew

  TYPES = ['operational','training']

  humanized_attributes :spot => "Spotter"

  #attr_protected :creator_id, :id #These attributes must be protected in the controller with "strong parameters"

  def crew
    #an operation belongs to the crew that the creator was on during the year that they created the operation.
    return nil if self.new_record?
    @crew ||= self.creator.crew(self.created_at.year)
  end

  def associated_crews
    #an operation is associated with its creator's crew as well as the crews of its rappellers.
    crews = []
    crews.push self.crew
    self.rappellers.each do |r|
      crews.push(r.person.current_or_most_recent_crew) unless crews.include? r.person.current_or_most_recent_crew
    end
    return crews
  end

  def editable_by?(person)
    return true if self.new_record?
    person.has_authorization?(Authorizations::EDIT_OPERATIONS) && person.current_crew == self.crew
  end

  def pilot_fullname=(name)
    @pilot_fullname = name
    if p = Person.find_by_fullname(name)
      self.pilot = Pilot.find_by_person_id(p.id)
    else
      self.pilot = nil
    end
  end

  def pilot_fullname
    if self.pilot
      return @pilot_fullname ||= self.pilot.person.fullname
    end
    return ""
  end

  def spotter_fullname
    if self.spotter
      return self.spotter.person.fullname
    end
  end

  def rappel(options)
    return self.rappels.select { |r| r.door == options[:door] and r.stick == options[:stick] }.first
  end

  def aircraft_name_and_config=(str)
    #expects a string of the form "aircraft_shortname configuration" e.g. "bell 205 bench"
    #or, if configuration is not applicable, just the aircraft shortname e.g. "astar b3"
    arr = str.strip.split(" ")
    if arr.last.downcase == "bench" || arr.last.downcase == "hellhole"
      config = arr.last
      arr.delete(config)
      name = arr.join(" ")
      self.aircraft_type = AircraftType.find(:first, :conditions => ["shortname LIKE ? AND configuration LIKE ?", name, config])
    else
      self.aircraft_type = AircraftType.find(:first, :conditions => ["shortname LIKE ?", str])
    end
  end

  def aircraft_name_and_config
    if self.aircraft_type
      return self.aircraft_type.name_and_config
    end
  end

  def aircraft_shortname
    if self.aircraft_type
      return self.aircraft_type.shortname
    end
  end

  def self.find_all_by_crew(crew_id)
    Operation.find(:all,
                   :joins => "INNER JOIN rappels ON operations.id = rappels.operation_id
                              INNER JOIN rappellers ON rappels.rappeller_id = rappellers.id
                              INNER JOIN people ON rappellers.person_id = people.id
                              INNER JOIN rostered_people ON people.id = rostered_people.person_id
                              INNER JOIN rosters ON rostered_people.roster_id = rosters.id
                              INNER JOIN crews ON rosters.crew_id = crews.id",
                   :conditions => ["crews.id = ? AND rosters.year = ?", crew_id, Time.now.year],
                   :group => :id,
                   :order => "date DESC")
  end

  def self.find_all_by_rappeller(person_id)
    Rappeller.find_by_person_id(person_id).nil? ? [] : Rappeller.find_by_person_id(person_id).rappels.collect {|t| t.operation}
  end

  def self.find_all_by_spotter(person_id)
    RappelSpotter.find_by_person_id(person_id).nil? ? [] : RappelSpotter.find_by_person_id(person_id).operations
  end
end

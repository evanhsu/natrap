class Crew < ActiveRecord::Base
  has_many :rosters
  has_many :ro_bo_states
  has_many :scheduled_courses
  has_many :training_facilities
  has_many :people, :through => :rosters
  has_many :items
  has_many :training_priorities
  has_many :addresses, :class_name => "CrewAddress", :inverse_of => :crew, :dependent => :destroy
  has_many :requisitions, dependent: :destroy
  has_many :requisition_line_items, through: :requisitions
  has_and_belongs_to_many :dandies
  has_many :cardholders
  accepts_nested_attributes_for :addresses, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :rosters, :allow_destroy => true, :reject_if => :all_blank
  has_attached_file :logo,
                    :path => ":rails_root/public/images/crew_logos/:id-:style.:extension",
                    :url => "/images/crew_logos/:id-:style.:extension",
                    :default_url => "/images/magnifying_glass.png"

  validates :name, :abbrev, :region, :presence => true
  validates_uniqueness_of :name, :abbrev

  def self.qualifications_to_summarize
    { "ICT5" => ["ICT5"], "HECM" => ["HECM"],        "EMTB+"=> ["EMTB","EMTA"],
      "ICT4" => ["ICT4"], "HMGB" => ["HMGB"],        "WFR"  => ["WFR"],
      "ICT3" => ["ICT3"], "HERS" => ["HERS"],        "CFAL" => ["CFAL"],
      "CRWB" => ["CRWB"], "HEB2+"=> ["HEB1","HEB2"]
    }
  end

  def self.order_of_qualifications
    # This array retains the desired order for these quals to be displayed.
    # Ruby 1.8.x does NOT retain the order of values within a Hash (only arrays)
    # This is needed for Dreamhost's 1.8.x version of Ruby.
    ["ICT5","HECM","EMTB+","ICT4","HMGB","WFR","ICT3","HERS","CFAL","CRWB","HEB2+"]
  end

  def address(address_type = "mailing_address")
    if !CrewAddress.find_by_crew_id_and_address_type(self.id,address_type).nil?
      CrewAddress.find_by_crew_id_and_address_type(self.id,address_type).address
    else
      nil
    end
  end

  def admins
    self.people(:having => "account_type LIKE '%admin'")
  end

  def current_people(options = {})
    options.delete(:year) unless (options[:year]).nil?
    self.people(options)
  end

  def enrollments
    Enrollment.find_all_by_crew self.id
  end

  def people(options = {})
    options[:year] ||= Time.now.year
    person_ids = Roster.find_all_by_crew_id_and_year(self.id, options[:year].to_s).collect { |r| r.people }.flatten.collect {|y| y.id}
    options.delete(:year)
    Person.find_all_by_id(person_ids, options)
  end

  def operations
    Operation.find_all_by_crew self.id
  end

  def self.group_by_region_for_select
    groups = {}
    crews = Crew.all
    crews.each do |c|
      key = "Region #{c.region.to_s}"
      groups[key] = [] if groups[key].nil?
      groups[key] << [c.name, c.id]
    end
    return groups
  end

end

class ScheduledCourse < ActiveRecord::Base
  belongs_to :training_facility
  belongs_to :crew
  has_many :enrollments, :dependent => :destroy
  has_many :people, :through => :enrollments
  accepts_nested_attributes_for :training_facility
  accepts_nested_attributes_for :enrollments

  #validates :date_start, :date_end, :name, :presence => true
  validates :name, :presence => true

  humanized_attributes :date_start => "Start date", :date_end => "End date"

  #default_scope :order => 'date_start DESC'
  scope :oldest_first, :order => 'date_start'

  def self.find_all_by_date_range(options = {})
    return if options[:start] and (options[:start].class.name != "Date")
    return if options[:end] and (options[:end].class.name != "Date")

    start_condition = options[:start]  #A Date object (or nil)
    end_condition = options[:end]      #A Date object (or nil)
    other_conditions = options[:conditions].to_s ||= "1"
    options[:order] ||= "scheduled_courses.date_start DESC"

    options.delete(:start)
    options.delete(:end)
    options.delete(:conditions)

    date_conditions = ""
    date_conditions += "date_end >= '" + start_condition.to_s + "'" unless start_condition.nil?
    date_conditions += " AND " unless (date_conditions.blank? or end_condition.nil?)
    date_conditions += "date_start <= '" + end_condition.to_s + "'" unless end_condition.nil?
    date_conditions += date_conditions.blank? ? "1":" OR date_start IS NULL" #If no date conditions have been set, this will remove restrictions from the SQL query: "select... where 1"

    options[:conditions] = "(" + date_conditions + ") and (" + other_conditions + ")"

    ScheduledCourse.find(:all, options, :include => :training_facility)
  end
end

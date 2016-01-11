class Enrollment < ActiveRecord::Base
  belongs_to :person
  belongs_to :scheduled_course

  validates :person_id, :scheduled_course_id, :presence => true
  validates_uniqueness_of :person_id, :scope => :scheduled_course_id, :message => "That person is already enrolled in that course."

  ENROLLMENT_STATUSES = ['nominated','waitlisted','enrolled']
  
  def crew
    #Returns the crew that this enrollment's person belonged to during the year of the enrollment.
    #If the person did not belong to a crew during the course year, return that person's most recent crew (as of the course date).
    #Return the crew that created the schedule_course if person never belonged to a crew prior to the course date
    return self.scheduled_course.crew if self.scheduled_course.date_start.nil?
    
    course_year = self.scheduled_course.date_start.year
    self.person.last_crew_as_of(course_year)
  end

  def accounting_total
    (self.cost_tuition or 0.0) + (self.cost_wages or 0.0) + (self.cost_travel or 0.0) + (self.cost_misc or 0.0)
  end

  def warnings(options={})
    sd = self.scheduled_course.date_start
    ed = self.scheduled_course.date_end
    td = Date.today
    options[:output_as] ||= "list"
    reasons = []

    #Coming up soon (within 7 days)
    if(!sd.nil? and (sd > td) and (sd <= (td + 1.week)))
      reasons.push "This course starts in #{((sd - td).days / 3600 / 24).round.to_s} days"
    end

    #Prework NOT received AND course starts in 10 days or less
    if(!sd.nil? and (sd > td) and (sd <= (td + 10.days)) and !self.prework_received)
      reasons.push "This student has not received the course pre-work"
    end

    #Certificate NOT received AND course ended
    if(!ed.nil? and (ed < td) and !self.certificate_received)
      reasons.push "This student did not receive a certificate"
    end

    #Travel NOT paid AND course ended
    if(!ed.nil? and (ed < td) and !self.travel_paid)
      reasons.push "A travel voucher has not been submitted"
    end

    #Student enrolled in overlapping courses (date conflict)
    conflicting_enrollments = Enrollment.joins(:scheduled_course).find_all_by_person_id(self.person_id, :conditions => ["((scheduled_courses.date_start <= ?) AND (? <= scheduled_courses.date_end) AND (enrollments.id != ?))",ed,sd,self.id]) if (!ed.nil? and !sd.nil?)
    unless conflicting_enrollments.blank?
      reasons.push "This student is enrolled in another course during these dates"
    end

    case options[:output_as]
      when "list" then
        output = ""
        reasons.each {|r| output += "<li>#{r}</li>\n"}
      when "array" then
        output = []
        reasons.each {|r| output.push r}
      when "element_properties" then
        reasons.length > 0 ? output = "style=\"background-color:#eeee00\" title=\"Attention: " + reasons.to_sentence + "\" " : output = ""
      else output = options.length.to_i
    end
    return output
  end #warnings()

  def warnings?()
    return true if self.warnings().length > 0
    return false
  end

  def self.find_all_by_crew(crew_id)
    # This function will return a list of Enrollment objects that are associated
    # with the designated crew where scheduled_course.crew_id = crew_id.
    # NOTE: each enrollment in this list does not necessarily refer to a Person
    # who belongs to this crew's Roster.  The people in this list are merely
    # attending a Scheduled_course that was created by this crew.
    Enrollment.includes(:scheduled_course).includes(:person).where("scheduled_courses.crew_id = %", crew_id).order("scheduled_courses.start_date")

    #joins(:scheduled_course).joins("LEFT OUTER JOIN rostered_people ON rostered_people.person_id = enrollments.person_id").joins("LEFT OUTER JOIN rosters ON rosters.id = rostered_people.roster_id").where("rosters.crew_id = ? AND rosters.year = date_format(scheduled_courses.DATE_START,'%Y')", crew_id)
  end

  def self.find_all_by_date_range_and_crew(options = {})
    return if options[:start] and (options[:start].class.name != "Date")
    return if options[:end] and (options[:end].class.name != "Date")
    return if options[:crew_id].blank? #options[:crew_id] is required

    start_condition = options[:start]  #A Date object (or nil)
    end_condition = options[:end]      #A Date object (or nil)
    crew_id = options[:crew_id]
    other_conditions = "1" if options[:conditions].to_s.blank?
    options[:order] ||= "scheduled_courses.date_start DESC"

    options.delete(:start)
    options.delete(:end)
    options.delete(:crew_id)

    date_conditions = ""
    date_conditions += "date_end >= '" + start_condition.to_s + "'" unless start_condition.nil?
    date_conditions += " AND " unless (date_conditions.blank? or end_condition.nil?)
    date_conditions += "date_start <= '" + end_condition.to_s + "'" unless end_condition.nil?
    
    date_conditions += date_conditions.blank? ? "1":" OR date_start IS NULL" #If no date conditions have been set, this will remove restrictions from the SQL query: "select... where 1"


    options[:conditions] = "(" + date_conditions + ") and (" + other_conditions + ") and (scheduled_courses.crew_id = "+crew_id.to_s+")"

    #Crew.find(crew_id).enrollments.includes(:scheduled_course, :person).find(:all, options)
    Enrollment.includes(:scheduled_course, :person).find(:all, options)
  end




  def self.find_all_by_date_range_and_person(options = {})
    person_id = options[:person_id]
    start_of_range = "(scheduled_courses.date_end >= '#{options[:start].to_s}')" if options[:start]
    end_of_range = "(scheduled_courses.date_start <= '#{options[:end].to_s}')" if options[:end]
    other_conditions = "AND (#{options[:conditions]})" if options[:conditions]
    order_by = options[:order]

    start_of_range ||= "1"
    end_of_range ||= "1"

    Enrollment.includes(:scheduled_course).where("(enrollments.person_id = ?) and ((#{start_of_range} and #{end_of_range}) or (scheduled_courses.date_start IS NULL)) #{other_conditions}", person_id).order(order_by)
  end
end

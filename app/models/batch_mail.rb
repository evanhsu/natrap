class BatchMail

  def self.distribute_upcoming_course_reminder_email
    crews = Crew.all
    crews.each do |crew|
      @crew = crew
      @lookahead_period = 3.weeks
      @start_date = Date.today
      @end_date = @start_date + @lookahead_period
      @email_recipients = crew.admins.collect {|c| c.username}.join(",")
      @courses = Array.new

      @crew.enrollments.order(:date_start).each do |enrollment|
        @courses.push(enrollment.scheduled_course) if (enrollment.scheduled_course.date_start - Date.today).to_i.days.between?(0.days,@lookahead_period)
      end
      @courses.uniq! #Eliminate duplicates

      if (@email_recipients.length > 0 && @courses.count > 0)
        NatrapMailer.upcoming_crew_enrollment_summary_email(@crew,@email_recipients,@courses,@start_date,@end_date).deliver
      end
    end #End crews.each do |crew|

  end

  def self.distribute_follow_up_after_crew_enrollment_email
    # Send an email to the CREW ADMINs for each crew with a summary of completed
    # courses that still require action (i.e. travel vouchers & 'certificate_received')
    crews = Crew.all
    crews.each do |crew|
      @crew = crew
      @email_recipients = crew.admins.collect {|c| c.username}.join(",")
      #@email_recipients = "evanhsu@gmail.com"

      # Build a list of enrollments that have already ended, but 'certificate_received' OR 'travel_completed' are FALSE
      @enrollments = crew.enrollments.order("date_end DESC").select {|e| e.scheduled_course.date_end < Date.today}.select {|e| e.certificate_received != true || e.travel_paid != true}

      if (@email_recipients.length > 0 && @enrollments.count > 0)
        NatrapMailer.follow_up_after_crew_enrollment_email(@crew,@email_recipients,@enrollments).deliver
      end
    end #End crews.each do |crew|

  end #End def self.send_training_course_follow_up_email

  def self.distribute_student_reminder_email
    # Send an email to each student 1 week before their scheduled course.
    # This should be run daily
    @trigger_date = Date.today + 1.week

    @enrollments = Enrollment.includes(:person,:scheduled_course).where("scheduled_courses.date_start = date(?)",@trigger_date)
    @enrollments.each do |e|
      NatrapMailer.your_upcoming_course_email(e.person,e).deliver
    end
  end
end

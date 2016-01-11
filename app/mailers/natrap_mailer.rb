class NatrapMailer < ActionMailer::Base
  default :from => "NatRap Notification <notifier@natrap.com>"

  def password_reset_email(person, password)
    @person = person
    @password = password
    @login_url = "http://natrap.com"
    @email_address = person.username
    mail(:to => @email_address, :subject => "Your password has been reset")
  end

  def new_account_email(person, password)
    @person = person
    @username = person.username
    @password = password
    @login_url = "http://natrap.com"
    @email_address = person.username
    mail(:to => @email_address, :subject => "Welcome to Natrap.com!")
  end

  def your_upcoming_course_email(student, enrollment)
    # Send an email to the student with all the course info:
    # (date, location, enrollment status, crewmembers attending, etc)
    @student = student
    @enrollment = enrollment
    @course = @enrollment.scheduled_course
    @training_facility = @course.training_facility
    @attendees = @course.people.all(:order => "people.firstname, people.lastname")
    mail(:to => @student.username, :subject => "Upcoming Training Course: #{@course.name} on #{@course.date_start}")
  end

  def upcoming_crew_enrollment_summary_email(crew,email_recipients,courses,start_date,end_date)
    # Send an email to the CREW ADMINs with a summary of all upcoming course enrollments
    @crew = crew
    @email_recipients = email_recipients
    @courses = courses
    @start_date = start_date
    @end_date = end_date
  
    mail(:to => @email_recipients, :subject => "Upcoming Training Courses for the #{crew.name}")
  end

  def follow_up_after_crew_enrollment_email(crew,email_recipients,enrollments)
    # Send an email to the CREW ADMINs with a summary of completed courses that still require action
    # i.e. travel vouchers & 'certificate_received'
    @crew = crew
    @email_recipients = email_recipients
    @enrollments = enrollments
    
    mail(:to => @email_recipients, :subject => "Follow-up on Recent Training Courses for the #{@crew.name}")
  end

end

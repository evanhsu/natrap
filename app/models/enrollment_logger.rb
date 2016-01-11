class EnrollmentLogger < ActionController::Caching::Sweeper
  observe Enrollment
  
  def after_create(enrollment)
    #Make a log entry to associate with the enrollment
    LogEntry.create(:person_id => current_person.id,
                    :instance_id => enrollment.id,
                    :model_name => 'Enrollment',
                    :action=> 'create',
                    :attribute_name => '',
                    :old_value => '',
                    :new_value => '',
                    :comments  => "#{enrollment.person.fullname} was enrolled in #{enrollment.scheduled_course.name}.")
    
    #Make a log entry to associate with the scheduled_course
    LogEntry.create(:person_id => current_person.id,
                    :instance_id => enrollment.scheduled_course_id,
                    :model_name => 'ScheduledCourse',
                    :action=> 'update',
                    :attribute_name => '',
                    :old_value => '',
                    :new_value => '',
                    :comments  => "#{enrollment.person.fullname} was enrolled.")

  end #End of 'after_create()'

  
  def after_update(enrollment)

    #Create a new log entry for each individual attribute that was updated
    enrollment.attributes.each do |attribute,value|
      old_value = enrollment.send(attribute+'_was')
      unless ((value == old_value) or (attribute == 'updated_at')) #Look for changed attributes and log them

        LogEntry.create(:person_id => current_person.id,
                        :instance_id => enrollment.id,
                        :model_name => 'Enrollment',
                        :action=> 'update',
                        :attribute_name => attribute.to_s,
                        :old_value => old_value.to_s,
                        :new_value => value.to_s,
                        :comments  => "#{attribute} changed from #{old_value.blank? ? "blank":old_value.to_s} to #{value}.")
      end #End of 'unless'
    end #End of 'enrollment.attributes.each do'
  end #End of 'after_update()'


  def after_destroy(enrollment)
    #Make a log entry to associate with the scheduled_course
    LogEntry.create(:person_id => current_person.id,
                    :instance_id => enrollment.scheduled_course_id,
                    :model_name => 'ScheduledCourse',
                    :action=> 'update',
                    :attribute_name => '',
                    :old_value => '',
                    :new_value => '',
                    :comments  => "#{enrollment.person.fullname} was dropped.")
  end

end #End of class
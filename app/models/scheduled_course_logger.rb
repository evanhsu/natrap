class ScheduledCourseLogger < ActionController::Caching::Sweeper
  observe ScheduledCourse

  def after_save(scheduled_course)
    if scheduled_course.date_start.blank?
      comment = "#{scheduled_course.name} was scheduled for an unknown date."
    else
      comment =  "#{scheduled_course.name} was scheduled for #{scheduled_course.date_start.strftime(DATE_FORMAT_PATTERN)} through #{scheduled_course.date_end.strftime(DATE_FORMAT_PATTERN)}"
    end
    LogEntry.create(:person_id => current_person.id,
                    :instance_id => scheduled_course.id,
                    :model_name => 'ScheduledCourse',
                    :action=> 'create',
                    :attribute_name => '',
                    :old_value => '',
                    :new_value => '',
                    :comments  => comment)
  end #End of 'after_create()'


  def after_update(scheduled_course)

    #Create a new log entry for each individual attribute that was updated
    scheduled_course.attributes.each do |attribute,value|
      old_value = scheduled_course.send(attribute+'_was')
      unless ((value == old_value) or (attribute == 'updated_at')) #Look for changed attributes and log them

        LogEntry.create(:person_id => current_person.id,
                        :instance_id => scheduled_course.id,
                        :model_name => 'ScheduledCourse',
                        :action=> 'update',
                        :attribute_name => attribute.to_s,
                        :old_value => old_value.to_s,
                        :new_value => value.to_s,
                        :comments  => "#{attribute} changed from #{old_value.blank? ? "blank":old_value.to_s} to #{value}")
      end #End of 'unless'
    end #End of 'scheduled_course.attributes.each do'
  end #End of 'after_update()'

end #End of class

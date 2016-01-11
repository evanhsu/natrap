class ScheduledCoursesController < ApplicationController
  before_filter :require_login
  before_filter do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::VIEW_SCHEDULED_COURSES, Authorizations::EDIT_SCHEDULED_COURSES),
           c.send(:enforce, current_person.current_crew.id == ScheduledCourse.find(params[:id]).crew_id))
  end

  
  # GET /scheduled_courses
  # GET /scheduled_courses.xml
  def index
    @scheduled_courses = ScheduledCourse.find(:all, :conditions => ["(scheduled_courses.crew_id = ?) & (" + date_conditions_from_params() + ")", current_person.current_crew.id])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scheduled_courses }
    end
  end

  # GET /scheduled_courses/1
  # GET /scheduled_courses/1.xml
  def show
    @scheduled_course = ScheduledCourse.find(params[:id])
    @people_enrolled = @scheduled_course.people.all(:order => "people.firstname, people.lastname")
    @log_messages=LogEntry.find(:all, :conditions => "model_name = 'ScheduledCourse' and instance_id = #{@scheduled_course.id}", :order => "created_at DESC", :limit => 7)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scheduled_course }
    end
  end

end
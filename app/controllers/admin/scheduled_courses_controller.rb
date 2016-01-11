class Admin::ScheduledCoursesController < ApplicationController
  before_filter :require_login
  before_filter :only => [:edit, :update, :destroy] do |c|
    c.send(:enforce, current_person.current_crew.id == ScheduledCourse.find(params[:id]).crew_id.to_i)
    c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_SCHEDULED_COURSES))
  end
  before_filter :only => :create do |c|
    c.send(:enforce, current_person.current_crew.id == params[:scheduled_course][:crew_id].to_i)
    c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_SCHEDULED_COURSES))
  end
  before_filter :only => [:show, :index] do |c|
    c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_SCHEDULED_COURSES))
  end
  cache_sweeper :scheduled_course_logger

  
  # GET admin/scheduled_courses
  # GET admin/scheduled_courses.xml
  def index
    @scheduled_courses = ScheduledCourse.find(:all, :conditions => ["(scheduled_courses.crew_id = ?) & (" + date_conditions_from_params() + ")", current_person.current_crew.id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scheduled_courses }
    end
  end

  # GET admin/scheduled_courses/1
  # GET admin/scheduled_courses/1.xml
  def show
    @scheduled_course = ScheduledCourse.find(params[:id])
    @people_enrolled = @scheduled_course.people.all(:order => "people.firstname, people.lastname")
    @log_messages = LogEntry.find(:all, :conditions => "model_name = 'ScheduledCourse' and instance_id = '#{@scheduled_course.id}'", :order => "created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scheduled_course }
    end
  end

  # GET admin/scheduled_courses/new
  # GET admin/scheduled_courses/new.xml
  def new
    @scheduled_course = ScheduledCourse.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scheduled_course }
    end
  end

  # GET admin/scheduled_courses/1/edit
  def edit
    @scheduled_course = ScheduledCourse.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scheduled_course }
    end
  end

  # POST admin/scheduled_courses
  # POST admin/scheduled_courses.xml
  def create
    @scheduled_course = ScheduledCourse.new(params[:scheduled_course])
    #Convert date from m/d/y (as entered on the form) to Y/m/d (as required by the database)
    params[:scheduled_course][:date_start] = Date.strptime(params[:scheduled_course][:date_start],"%m/%d/%Y").strftime("%Y-%m-%d") unless params[:scheduled_course][:date_start].blank?
    params[:scheduled_course][:date_end] = Date.strptime(params[:scheduled_course][:date_end],"%m/%d/%Y").strftime("%Y-%m-%d") unless params[:scheduled_course][:date_end].blank?


    respond_to do |format|
      if @scheduled_course.save
        format.html { redirect_to admin_scheduled_course_url(@scheduled_course), :notice => 'This course was successfully created.' }
        format.xml  { render :xml => @scheduled_course, :status => :created, :location => @scheduled_course }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scheduled_course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT admin/scheduled_courses/1
  # PUT admin/scheduled_courses/1.xml
  def update
    @scheduled_course = ScheduledCourse.find(params[:id])
    #Convert date from m/d/y (as entered on the form) to Y/m/d (as required by the database)
    params[:scheduled_course][:date_start] = Date.strptime(params[:scheduled_course][:date_start],"%m/%d/%Y").strftime("%Y-%m-%d") unless params[:scheduled_course][:date_start].blank?
    params[:scheduled_course][:date_end] =   Date.strptime(params[:scheduled_course][:date_end],"%m/%d/%Y").strftime("%Y-%m-%d") unless params[:scheduled_course][:date_end].blank?

    respond_to do |format|
      if @scheduled_course.update_attributes(params[:scheduled_course])
        format.html { redirect_to admin_scheduled_course_url(@scheduled_course), :notice => 'The course was successfully updated.' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scheduled_course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE admin/scheduled_courses/1
  # DELETE admin/scheduled_courses/1.xml
  def destroy
	# The scheduled_course model specifies: has_many :enrollments, dependent: :destroy
	# So related enrollments will be destroyed automatically when the scheduled_course is destroyed.
    @scheduled_course = ScheduledCourse.find(params[:id])
    @scheduled_course.destroy

    respond_to do |format|
      format.html { redirect_to(scheduled_courses_for_admin_crew_url(current_person.current_crew())) }
      format.xml  { head :ok }
    end
  end
end

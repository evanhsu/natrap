class Admin::EnrollmentsController < ApplicationController
  before_filter :require_login
  before_filter do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::EDIT_ENROLLMENTS))
  end
  before_filter :only => :create do |c|
    c.send(:enforce,
           [current_person.current_crew.id == Person.find(params[:enrollment][:person_id]).current_crew.id,
            "You may only enroll members of your own crew."],
           [current_person.current_crew.id == ScheduledCourse.find(params[:enrollment][:scheduled_course_id]).crew.id,
            "You may not enroll students in another crew's course."])
  end
  before_filter :only => :update do |c|
    c.send(:enforce,
           [current_person.current_crew.id == Enrollment.find(params[:id]).crew.id,
            "You may only edit the enrollments of your own crewmembers."])
  end
  before_filter :only => [:edit, :destroy, :show] do |c|
    c.send(:enforce, current_person.current_crew.id == Enrollment.find(params[:id]).person.last_crew_as_of().id)
  end
  cache_sweeper :enrollment_logger

  # GET /admin/enrollments
  def index
    @enrollments = Crew.find(params[:id]).enrollments.find(:all, :conditions => date_conditions_from_params(),:include => :person, :order => sort_order("scheduled_courses.date_start","down"))
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @enrollments }
    end
  end

  # GET /admin/enrollments/1
  def show
    @enrollment = Enrollment.find(params[:id])
    @log_messages=LogEntry.find(:all, :conditions => "model_name = 'Enrollment' and instance_id = '#{@enrollment.id}'", :order => "created_at DESC", :limit => 15)

    respond_to do |format|
      format.html
      format.xml { render :xml => @enrollment }
    end
  end

  # GET /admin/enrollments/new
  # GET /admin/enrollments/new.xml
  def new
    @enrollment = Enrollment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @enrollment }
    end
  end

  # GET /admin/enrollments/1/edit
  def edit
    @enrollment = Enrollment.find(params[:id])
  end

  # POST /enrollments
  # POST /enrollments.xml
  def create
    @enrollment = Enrollment.new(params[:enrollment])

    respond_to do |format|
      if @enrollment.save
        @log_entry = LogEntry.last
        format.html { redirect_to admin_scheduled_course_url(@enrollment.scheduled_course), :notice => 'A student was successfully enrolled.' }
        #format.xml  { render :xml => @enrollment, :status => :created, :location => @enrollment }
      else
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @enrollment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/enrollments/1
  # PUT /admin/enrollments/1.xml
  def update
    @enrollment = Enrollment.find(params[:id])

    respond_to do |format|
      if @enrollment.update_attributes(params[:enrollment])
        @log_entry = LogEntry.last
        format.html { redirect_to @enrollment, :notice => 'The details of this enrollment have changed.' }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @enrollment.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # DELETE /admin/enrollments/1
  # DELETE /admin/enrollments/1.xml
  def destroy
    @enrollment = Enrollment.find(params[:id])
    @scheduled_course = @enrollment.scheduled_course
    @enrollment.destroy

    respond_to do |format|
      if(current_person.current_crew)
        format.html { redirect_to admin_scheduled_course_url(@scheduled_course) }
      else
        format.html { redirect_to enrollments_url }
      end
      format.xml  { head :ok }
    end
  end
end

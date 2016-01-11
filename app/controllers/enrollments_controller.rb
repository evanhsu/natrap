class EnrollmentsController < ApplicationController
  before_filter :require_login
  before_filter do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::VIEW_ENROLLMENTS, Authorizations::EDIT_ENROLLMENTS),
           current_person.current_crew.id == Enrollment.find(params[:id]).crew.id)
  end

  # GET /enrollments
  # GET /enrollments.xml
  def index
    #@enrollments = Crew.find(params[:id]).enrollments.find(:all, :conditions => date_conditions_from_params(), :include => :person, :order => sort_order("scheduled_courses.date_start","down"))

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @enrollments }
    end
  end

  # GET /enrollments/1
  # GET /enrollments/1.xml
  def show
    @enrollment = Enrollment.find(params[:id])
    @log_messages = LogEntry.find(:all, :conditions => "model_name = 'Enrollment' and instance_id = '#{@enrollment.id}'", :order => "created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @enrollment }
    end
  end
end

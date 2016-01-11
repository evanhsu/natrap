class Admin::CrewsController < ApplicationController
  before_filter :require_login
  before_filter :except => [:index] do |c|
    c.send(:enforce,
      (current_person.current_crew.nil? ? false:current_person.current_crew.id == params[:id].to_i) || current_person.account_type == 'global_admin'
      )
  end
  before_filter :only => [:index, :show, :edit, :update, :destroy] do |c|
    c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_CREWS, Authorizations::EDIT_OWN_CREW))
  end
  before_filter :only => :enrollments do |c|
    c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_ENROLLMENTS))
  end
  before_filter :only => :scheduled_courses do |c|
    c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_SCHEDULED_COURSES))
  end
  before_filter :only => :operations do |c|
    c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_OPERATIONS))
  end
  before_filter :only => :training_facilities do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::EDIT_TRAINING_FACILITIES))
  end
  before_filter :only => :roster do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::EDIT_OWN_CREW)
         )
  end

  # GET admin/crews
  def index
    @crews = Crew.all

    respond_to do |format|
      format.html { redirect_to(crews_url) }
      format.xml  { head :ok }
    end
  end

  # GET admin/crews/1/dandies
  def dandies
    @crew = Crew.find(params[:id])
    @dandies = @crew.dandies

    respond_to do |format|
      format.html
    end
  end

  # GET admin/crews/1
  def show
    @crew = Crew.find(params[:id])
    @crewmembers = @crew.people(:year => @requested_year)
    @years_with_info = Roster.find_all_by_crew_id(@crew.id, :select => "DISTINCT year", :order => "year DESC").collect {|r| r.year}
    @all_crew_quals = Qualification.find_all_by_crew_and_year(params[:id], @requested_year) #All qualifications held by all crewmembers
    @quals_to_display = Hash.new #A subset of @all_crew_quals defined by Crew::qualifications_to_summarize
    @order_of_quals = Crew::order_of_qualifications

    Crew::qualifications_to_summarize.each do |title,quals|
      @quals_to_display[title] = {'qualified' => 0, 'trainee' => 0}
      quals.each do |qual|
        @quals_to_display[title]['qualified'] += @all_crew_quals[qual].nil? ? 0:@all_crew_quals[qual]['qualified']
        @quals_to_display[title]['trainee'] += @all_crew_quals[qual].nil? ? 0:@all_crew_quals[qual]['trainee']
      end
    end

    respond_to do |format|
      format.html
      format.xml  { head :ok }
    end
  end

  # GET admin/crews/1/edit
  def edit
    @crew = Crew.find(params[:id])

    respond_to do |format|
      format.html { redirect_to(crews_url) }
      format.xml  { head :ok }
    end
  end

  # PUT admin/crews/1
  def update
    @crew = Crew.find(params[:id])

    respond_to do |format|
      if @crew.update_attributes(params[:crew])
        format.html { redirect_to(@crew, :notice => 'Crew was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @crew.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET admin/crews/1/enrollments
  def enrollments
    @crew = Crew.find(params[:id])
    start_of_range = Date.strptime(params[:start],'%m/%d/%Y') unless params[:start].blank?
    end_of_range = Date.strptime(params[:end],'%m/%d/%Y') unless params[:end].blank?
    start_of_range, end_of_range, relation = get_implied_date_range_and_relation_to_today({:start => start_of_range, :end => end_of_range})

    @enrollments = Enrollment.find_all_by_date_range_and_crew({:start => start_of_range, :end => end_of_range, :crew_id => @crew.id, :order => sort_order("scheduled_courses.date_start","down")})
    @active_tab = relation

    respond_to do |format|
      format.html # enrollments.html.erb
      format.xml  { render :xml => @enrollments }
    end
  end

  # GET admin/crews/1/scheduled_courses
  def scheduled_courses
    @crew = Crew.find(params[:id])
    start_of_range = Date.strptime(params[:start],'%m/%d/%Y') unless params[:start].nil?
    end_of_range = Date.strptime(params[:end],'%m/%d/%Y') unless params[:end].nil?
    start_of_range, end_of_range, relation = get_implied_date_range_and_relation_to_today({:start => start_of_range, :end => end_of_range})

    @scheduled_courses = ScheduledCourse.find_all_by_date_range({:start => start_of_range, :end => end_of_range, :conditions => "scheduled_courses.crew_id = #{@crew.id}", :order => sort_order("scheduled_courses.date_start","down")})
    @enrollments = Enrollment.find_all_by_date_range_and_crew({:start => start_of_range, :end => end_of_range, :crew_id => @crew.id, :order => "people.firstname"})
    @active_tab = relation

    respond_to do |format|
      format.html # scheduled_courses.html.erb
      format.xml  { render :xml => @enrollments }
    end
  end

  # GET admin/crews/1/training_facilities
  def training_facilities
    @training_facilities = TrainingFacility.find_all_by_crew_id(params[:id]).sort_by { |a| a.name }
    @crew = Crew.find(params[:id])

    #BatchMail.distribute_follow_up_after_crew_enrollment_email
    respond_to do |format|
      format.html #training_facilities.html.erb
      format.xml { render :xml => @training_facilities }
    end
  end

  # GET admin/crews/1/qualifications
  def qualifications
    @crew_quals = Qualification.find_all_by_crew_and_year(params[:id], @requested_year = Time.now.year)
    @crew_quals_order = @crew_quals.sort_by { |k,v| k.to_s }.map { |key,value| key } #Maintain alphabetical order for Ruby < 1.9.x which doesn't order hashes
    @crew = Crew.find(params[:id])
    @crewmembers = @crew.people(:year => @requested_year).sort_by { |p| [p.firstname,p.lastname] }

    respond_to do |format|
      format.html #qualifications.html.erb
      format.xml { render :xml => @crew_quals }
    end
  end

  # GET admin/crews/1/operations
  def operations
    @crew = Crew.find(params[:id])
    @operations = Operation.find_all_by_crew(@crew.id)

    respond_to do |format|
      format.html #operations.html.erb
      format.xml { render :xml => @operations }
    end
  end

  # GET admin/crews/1/roster/:year
  def roster
    @crew = Crew.find(params[:id])
    @year = params[:year]
    @roster = Roster.find_by_crew_id_and_year(params[:id], params[:year])
    @rostered_people = RosteredPerson.find_all_by_roster_id(@roster.id)
    @new_rostered_person = RosteredPerson.new(:roster_id => @roster.id)

    respond_to do |format|
      format.html #roster.html.erb
      format.xml { render :xml => @roster }
    end
  end


end

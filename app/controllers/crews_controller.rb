class CrewsController < ApplicationController
  before_filter :require_login, :except => [:rotation_board,:rotation_board_by_date,:create_rotation_board_state,:add_booster_to_rotation_board]
  before_filter :except => [:index,:show,:rotation_board,:rotation_board_by_date,:create_rotation_board_state,:add_booster_to_rotation_board] do |c|
    c.send(:enforce,
      (current_person.current_crew.nil? ? false:current_person.current_crew.id == params[:id].to_i) || current_person.account_type == 'global_admin'
      )
  end
  before_filter :only => [:index,:show] do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::VIEW_CREWS, Authorizations::EDIT_CREWS, Authorizations::EDIT_OWN_CREW))
  end
  before_filter :only => :requisitions do |c|
#    c.send(:enforce,
#           current_person.has_authorization?(Authorizations::EDIT_BUDGET))
  end
  before_filter :only => :enrollments do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::VIEW_ENROLLMENTS, Authorizations::EDIT_ENROLLMENTS))
  end
  before_filter :only => :scheduled_courses do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::VIEW_SCHEDULED_COURSES, Authorizations::EDIT_SCHEDULED_COURSES))
  end
  before_filter :only => :operations do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::VIEW_OPERATIONS, Authorizations::EDIT_OPERATIONS))
  end
  before_filter :only => :training_facilities do |c|
    c.send(:enforce,
           current_person.has_authorization?(Authorizations::VIEW_TRAINING_FACILITIES, Authorizations::EDIT_TRAINING_FACILITIES))
  end

  # GET /crews
  # GET /crews.xml
  def index
    @region_id = params[:region_id]
    @crews = Crew.find_all_by_region(@region_id)
    @current_user = current_person
    #Collect regional stats here

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @crews }
    end
  end

  # GET /crews/1
  # GET /crews/1.xml
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

  # GET /crews/1/enrollments
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

  # GET /crews/1/budget
  def requisitions
    @crew = Crew.find(params[:id])
    #@new_requisition = Requisition.new #Initiate a new object just in case the user wants to create one since the 'Create New Requisition' form is embedded in this view.
    # List of requisitions should be requested via AJAX after the VIEW has loaded - add this behavior later.

    #The view can be customized to filter by date and cardholder, and sorted by any column in the table.
    #These settings are all stored in the session when the 'settings' form is submitted, but
    # if no view filters have been set, use defaults
        
    # Set start_date for dB query
    # Use a GET parameter if one was submitted, or the stored session variable if no param was sent, or else use the default value 
    # Coerce the @start_date and @end_date variables into  Date class objects
    @start_date = params[:start_date].presence || session[:start_date].presence || FiscalYear.new(FiscalYear.today).start_date
    session[:start_date] = @start_date.class.name == "Date" ? @start_date : Date.strptime(@start_date,"%m/%d/%Y")

    # Set end_date for dB query
    @end_date = params[:end_date].presence || session[:end_date].presence || FiscalYear.new(FiscalYear.today).end_date
    session[:end_date] = @end_date.class.name == "Date" ? @end_date : Date.strptime(@end_date,"%m/%d/%Y")

    # Set sort_by
    @sort_by = params[:sort_by].presence || session[:sort_by].presence || "date"
    session[:sort_by] = @sort_by
    
    # Collect all matching requisitions
    @requisitions = @crew.requisitions.where("(date >= ?) AND (date <= ?)",@start_date, @end_date).order(@sort_by, :date)


  end

  # GET /crews/1/scheduled_courses
  def scheduled_courses
    @crew = Crew.find(params[:id])
    start_of_range = Date.strptime(params[:start],'%m/%d/%Y') unless params[:start].blank?
    end_of_range = Date.strptime(params[:end],'%m/%d/%Y') unless params[:end].blank?
    start_of_range, end_of_range, relation = get_implied_date_range_and_relation_to_today({:start => start_of_range, :end => end_of_range})

    @scheduled_courses = ScheduledCourse.find_all_by_date_range({:start => start_of_range, :end => end_of_range, :conditions => "scheduled_courses.crew_id = #{@crew.id}", :order => sort_order("scheduled_courses.date_start","down")})
    @enrollments = Enrollment.find_all_by_date_range_and_crew({:start => start_of_range, :end => end_of_range, :crew_id => @crew.id, :order => "people.firstname"})
    @active_tab = relation

    respond_to do |format|
      format.html # scheduled_courses.html.erb
      format.xml  { render :xml => @enrollments }
    end
  end

  # GET /crews/1/training_facilities
  def training_facilities
    @training_facilities = TrainingFacility.find_all_by_crew_id(params[:id]).sort_by { |a| a.name }
    @crew = Crew.find(params[:id])
    
    respond_to do |format|
      format.html #training_facilities.html.erb
      format.xml { render :xml => @training_facilities }
    end
  end

  # GET /crews/1/qualifications
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

  # GET /crews/1/operations
  def operations
    @crew = Crew.find(params[:id])
    @operations = Operation.find_all_by_crew(@crew.id)

    respond_to do |format|
      format.html #operations.html.erb
      format.xml { render :xml => @operations }
    end
  end

  # GET /crews/1/rotation_board
  # GET /crews/1/robo
  # GET /crews/1/robo.json
  # GET /crews/1/rotation_board.xml
  def rotation_board
    # This action displays the CURRENT rotation board state. The logic in this case differs from recalling historical board states
    # in that the current crew roster is checked to see if there are any people on the roster who do are not represented on the rotation board.
    # If a person is missing from the rotation board, they will be added to the bottom of the list
    @crew = Crew.find(params[:id])
    #print "Crew: #{@crew.id}"

    # There is no need to look up position data to render the html page. That data
    # will be requested via AJAX once the page has loaded.
    respond_to do |format|
      format.html do
        render :layout => 'rotation_board'
      end
      format.xml { render :xml => @operations }
      format.json do
        @roBoState = RoBoState.current_state_for_crew(@crew.id)
	@roBoPositions = @roBoState.nil? ? [] : @roBoState.boardSnapshot()
	#@roBoPositions.each do |p|
	#	print p.personId
	#end
	roBoStateId = @roBoState.nil? ? nil : @roBoState.id
#print @roBoPositions
=begin
	#If there are crewmembers on the current roster who are not represented in the roBoPositions array, append them now.
	positioned_people_ids = @roBoPositions.collect {|p| p.personId}
	#Find people in the current roster who are NOT already positioned on the board and append them. These people will be displayed
	#at the bottom of the board, but will not actually be saved as a RoBoPosition until a change is made to the board to trigger
	#a new roBoState to be saved.
	crewmembers_not_positioned = @crew.current_people().reject {|crewmember| positioned_people_ids.include? crewmember.id}
	crewmembers_not_positioned.each do |crewmember|
		@roBoPositions << RoBoPosition.new(	"roBoStateId" => roBoStateId,
					"personId" => crewmember.id, 
					"role" => "", 
					"rank" => "",
					"person_name" => crewmember.fullname,
					"person_quals" => crewmember.qualifications.collect {|q| q.acronym}.join(","),
					"person_headshot_url" => crewmember.headshot.url,
					"listId" => "unassigned-list",
					"row" => @roBoPositions.length,
					"col" => 0 )

	end
=end
	render :json => @roBoPositions
      end
    end
  end

  # GET /crews/1/rotation_board/2014/07/10.json
  def rotation_board_by_date
    # Find the first RoBoState for this crew on the specified date OR the last RoBoState prior to this date
    # and return a JSON object with each RoBoPosition
    @requestedDate = Time.new(params[:year],params[:month],params[:day])
    @roBoPositions = RoBoState.find_by_crew_and_date(params[:id],@requestedDate).roBoPositions.order("listId,row")

    respond_to do |format|
      format.json {render :json => @roBoPositions }
    end
  end

  # POST /crews/1/add_booster_to_rotation_board
  def add_booster_to_rotation_board
    # If the "Add a Booster" form was submitted to trigger this controller action:
    #   -The params hash will include 'params[:person]' which will include :name,:quals,:headshot
    #   -A new Person must be created from the "Add a Booster" form data. If this fails, don't continue creating a new RoBoState.
    #   -A new RoBoState must be created.
    #   -A new RoBoPosition must be created that links the new Person (by ID) to the new RoBoState.
    #   -The new RoBoPosition must specify @roBoPosition.isBooster = true (so that those tiles can have a 'delete' button added to them).
    #   -The new person should be placed in the last row of the 'unassigned-list'.
    if(params.include?(:person_fullname))
        # The "Add a Booster" form was submitted with details for a new Person
        @booster = Person.new
        @booster.firstname, @booster.lastname = params[:person_fullname].split(" ",2) # Split "Baron Von Deutsche" into "Baron" and "Von Deutsche"
  #      @booster.headshot = params[:headshot]
        @booster.save()

        @currentRoBoState = Crew.find(params[:id]).ro_bo_states.order(:created_at).last # Get most recent roBoState for this crew (the CURRENT state)
        @roBoState = RoBoState.new
        @roBoState.user_id = 0 #Set this to the user id of the user currently logged in
        @roBoState.username = "fakeUsername"
        @roBoState.crew_id = params[:id]
        @roBoState.change_type = "add_booster"
        @roBoState.changed_person_id = @booster.id
        @roBoState.save()

        @currentRoBoState.roBoPositions.each do |pos|
          # Copy all of the roBoPositions from the latest roBoState into the newly-created roBoState
          new_pos = pos.dup
          new_pos.roBoStateId = @roBoState.id
          new_pos.save()
        end

        @booster_position = RoBoPosition.new
        @booster_position.roBoStateId = @roBoState.id
        @booster_position.personId = @booster.id
        @booster_position.role = ""
        @booster_position.rank = ""
        @booster_position.listId = "unassigned-list"
        @booster_position.row = @currentRoBoState.roBoPositions.where(listId: "unassigned-list").collect {|p| p.row}.max + 1
        @booster_position.col = 0
        @booster_position.person_name = params[:person_fullname]
        @booster_position.person_quals = params[:quals]
        @booster_position.save()
  #      @booster_position.person_headshot_url = params[:new_person][:headshot_file]
  #      @booster_position.isBooster = true

  #      render :action => :rotation_board
	redirect_to rotation_board_for_crew_url
     end
  end


  # POST /crews/1/rotation_board
  def create_rotation_board_state
    # Receive a JSON array of roBoPositions, save a snapshot of the entire board to the database

    @roBoState = RoBoState.new  # Change this to simply RoBoState.new(params) after figuring out the 'strong parameters'
    params[:RoBoState].each do |k,v|
      @roBoState[k] = v 
    end

    print @roBoState
    #@roBoState = RoBoState.new("crew_id" => params[:RoBoState][:crew_id],
    #				"user_id" => current_person.id,
    #				"username"=> current_person.fullname),
    #				"changeType"=>params[:RoBoState][:changeType],
    #				"changedPersonId"=>params[:RoBoState][:changedPersonId]
    if @roBoState.save()
	params[:RoBoPositions].each do |pos|
		# position = {0 => {listId:"myList", row:1, col:2, etc} Use position.second to get rid of the 0
		position = pos.second

		@roBoPosition = RoBoPosition.new
		@roBoPosition.roBoStateId = @roBoState.id
		@roBoPosition.personId = position[:personId]
		@roBoPosition.listId = position[:listId]
		@roBoPosition.row = position[:row]
		@roBoPosition.col = position[:col]
		@roBoPosition.role = position[:role]
		@roBoPosition.rank = position[:rank]
	
		# Look up this person's name,quals and photo instead of using the values from params to avoid tampering.
		@roBoPosition.person_name = @roBoPosition.person.fullname
		@roBoPosition.person_quals = @roBoPosition.person.qualifications.collect {|q| q.acronym}.join(",")
		@roBoPosition.person_headshot_url = @roBoPosition.person.headshot.url
		@roBoPosition.save() ||  @roBoState.delete

	end
    end
    render :nothing => true
    
  end

  private

  def roBoState_params
    params.permit!
  end

  def roBoPosition_params
    params.permit!
  end
end

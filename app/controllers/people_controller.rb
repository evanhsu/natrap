class PeopleController < ApplicationController
  before_filter :require_login, :except => [:forgotten_password, :reset_password, :signup, :create]
  before_filter(:only => :certificates) { |c| c.send(:require_self_or_permission, Authorizations::EDIT_CERTIFICATES,Authorizations::VIEW_CERTIFICATES)}
  before_filter(:only => :qualifications) { |c| c.send(:require_self_or_permission, Authorizations::EDIT_QUALIFICATIONS,Authorizations::VIEW_QUALIFICATIONS)}
  before_filter(:only => :enrollments) { |c| c.send(:require_self_or_permission, Authorizations::EDIT_ENROLLMENTS,Authorizations::VIEW_ENROLLMENTS)}
  before_filter(:only => [:show, :to_xml]) { |c| c.send(:require_self_or_permission, Authorizations::EDIT_PEOPLE,Authorizations::VIEW_PEOPLE)}
  before_filter(:only => :autocomplete) { |c| c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_PEOPLE,Authorizations::VIEW_PEOPLE))}


  # GET /people
  # GET /people.xml
  def index
    #@people = Person.all
    respond_to do |format|
      format.html { redirect_to admin_people_url } # /admin/people/index.html.erb
      format.xml  { render :xml => @people }
    end
  end
  
  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])
    @enrollments = Enrollment.joins(:scheduled_course).find_all_by_person_id(params[:id],:conditions => ["date_start >= ? or date_start IS NULL",Date.today.to_s],:order => "date_start DESC")
    @certificates = Certificate.find_all_by_person_id(params[:id], :order => :name)
    @qualifications = Qualification.find_all_by_person_id(params[:id], :order => :acronym)

    # current_person will be designated as a 'certificate_admin' under the following conditions:
    #   - Current person is accessing their own certificates
    #   - Current person is currently a member of the same crew as the requested person
    #   - Current person is currently a member of the requested person's most recent crew (if the requested person has no current crew)
    user_and_subject_same_crew = !current_person.current_crew.nil? and
                                 !@person.current_or_most_recent_crew.nil? and
                                 current_person.current_crew.id == @person.current_or_most_recent_crew.id
    @certificate_admin = (@person.id == current_person.id) or
                          (current_person.has_authorization?(Authorizations::EDIT_CERTIFICATES) and user_and_subject_same_crew)
    # current_pseron will be designated as a 'qualification_admin' under the same conditions as 'certificate_admin' (except with the appropriate authorizations)
    @qualification_admin = (@person.id == current_person.id) or
                          (current_person.has_authorization?(Authorizations::EDIT_QUALIFICATIONS) and user_and_subject_same_crew)
    # current_person will be designated as an 'enrollment_admin' under the same conditions as 'certificate_admin' (except with the appropriate authorizations)
    @enrollment_admin = (@person.id == current_person.id) or
                          (current_person.has_authorization?(Authorizations::EDIT_ENROLLMENTS) and user_and_subject_same_crew)
    @operation_admin = @person.has_authorization?(Authorizations::EDIT_OPERATIONS)
    
    # If specified year is NOT VALID (and within a sensible range) then use the current year
    @year = (!params[:year].blank? and params[:year].scan(/\D/).empty? and (2000..2100).include?(params[:year].to_i)) ? params[:year]:Date.today.year

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    #@person = Person.new
    #Defer to the ADMIN/people_controller to handle the creation of new people.
    respond_to do |format|
      format.html { redirect_to new_admin_person_url } # /admin/people/new.html.erb
      #format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
    respond_to do |format|
      format.html { redirect_to edit_admin_person_url(params[:id]) } # /admin/people/1/edit.html.erb
    end
  end

  # GET /people/1/certificates
  def certificates
    @person = Person.find(params[:id])
    @certificates = Certificate.find_all_by_person_id(params[:id], :order => :name)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @certificates }
    end
  end

  # GET /people/1/qualifications
  def qualifications
    @person = Person.find(params[:id])
    @qualifications = Qualification.find_all_by_person_id(params[:id], :order => :acronym)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @qualifications }
    end
  end

  # GET /people/1/operations
  def operations
    @active_tab = params[:view].blank? ? "rappels" : params[:view] #either 'rappels' or 'spots'
    @person = Person.find(params[:id])
    @rappels = Operation.find_all_by_rappeller(params[:id])
    @spots = Operation.find_all_by_spotter(params[:id])
    @operations = (@active_tab=="rappels") ? @rappels : @spots

    respond_to do |format|
      format.html
      format.xml  { render :xml => @rappels }
    end
  end

  # GET people/1/enrollments
  def enrollments
    @person = Person.find(params[:id])
    start_of_range = Date.strptime(params[:start],'%m/%d/%Y') unless params[:start].blank?
    end_of_range = Date.strptime(params[:end],'%m/%d/%Y') unless params[:end].blank?
    start_of_range, end_of_range, relation = get_implied_date_range_and_relation_to_today({:start => start_of_range, :end => end_of_range})

    @enrollments = Enrollment.find_all_by_date_range_and_person({:start => start_of_range, :end => end_of_range, :person_id => @person.id, :order => sort_order("scheduled_courses.date_start","down")})
    @active_tab = relation

    respond_to do |format|
      format.html
      format.xml  { render :xml => @enrollments }
    end
  end

  # GET /people/signup
  def signup
    @person = Person.new
    respond_to do |format|
      format.html # /signup.html.erb
    end
  end

  # POST /people
  # POST /people.xml
  def create
    #@person = Person.new(params[:person])
    # Create a new Person if this username (email) is not already in use
    # Or load the Person who is using the specified username
    @person = Person.create_with(params).find_or_create_by_username(:username => params[:person][:username])

    # If this Person already exists, check to see if there is already a password assigned.
    # If so, do not continue because this username already has a functioning account.
    # If not, it means that this Person was created by an admin (rather than the user themself)
    # and no password was generated.  In this case, continue generating a password.
    #
    # This should be updated to wait for a new user to login for the first time before
    # updating their information (confirm email before making changes to the account).
    unless(@person.encrypted_password.nil?)
      @person.errors.add(:username, "This email is already in use")
    end
    
    #Require a username (the Person model itself does not require a username, but will require a password once a username has been added)
    if(params[:person][:username].blank?)
      @person.errors.add(:username, "Your username must be a valid email address.")
    end
    @new_password = Person.generate_random_password
    @person.password = @new_password

    if(@person.crew.nil?)
      @person.account_type = "guest"  # New accounts created by anonymous users (not logged in) will
                                      # automatically be 'guests' until they are claimed by a crew and changed.
    else
      @person.account_type = "crewmember" # People who currently belong to a roster already will be created with
                                          # crewmember privileges
    end

    @person.has_purchase_card = 0;

    respond_to do |format|
      if @person.errors.empty? && @person.save
        NatrapMailer.new_account_email(@person,@new_password).deliver
        format.html { redirect_to root_path, :notice => "Your account has been created!  Your password has been emailed to you." }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "signup" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    # Defer to the ADMIN people_controller
    respond_to do |format|
      format.html { redirect_to(:controller => 'admin/people', :action => 'destroy', :id => params[:id]) }
    end
  end

  # GET /people/autocomplete
  def autocomplete
    @people = Person.find(:all, :conditions => ["CONCAT(firstname, CONCAT(' ', lastname)) LIKE ?", "%#{params[:query].strip}%"])
    @people = @people.sort_by { |p| p.fullname }
    response = {
      :query => params[:query],
      :suggestions => @people.map { |p| p.fullname },
      :data => @people.map { |p| p.id }
    }

    respond_to do |format|
      format.json { render :json => response.to_json }
    end
  end

  # GET /forgotten_password
  def forgotten_password
    respond_to do |format|
      format.html # people/forgotten_password.html
    end
  end

  # POST /reset_password
  def reset_password
    @person = Person.find_by_username(params['email'])
    @new_password = Person.generate_random_password

    respond_to do |format|
      if(@person && @person.password = @new_password)
        NatrapMailer.password_reset_email(@person,@new_password).deliver
        format.html { redirect_to :root, :notice => "Your password has been reset. The new password was emailed to #{@person.username}"}
      else
        format.html { render :action => "forgotten_password", :alert => "There is no account with that email address."}
      end
    end
  end


  def to_xml
    super(:only => [:salt, :encrypted_password])
  end

end

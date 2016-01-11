class Admin::PeopleController < ApplicationController
  before_filter :require_login
  before_filter(:only => :certificates) { |c| c.require_self_or_permission Authorizations::EDIT_CERTIFICATES}
  before_filter(:only => :qualifications) { |c| c.require_self_or_permission Authorizations::EDIT_QUALIFICATIONS}
  before_filter(:only => :enrollments) { |c| c.require_self_or_permission Authorizations::EDIT_ENROLLMENTS}
  before_filter :require_global_admin, :only => [:index,:to_xml]
  before_filter(:only => [:edit,:show,:update,:destroy]) { |c| c.require_self_or_permission Authorizations::EDIT_PEOPLE}
  before_filter(:only => [:new,:create]) { |c| c.send(:enforce, current_person.has_authorization?(Authorizations::CREATE_PEOPLE)) }
  before_filter :only => :operations do |c|
    c.send(:enforce, [current_person.has_authorization?(Authorizations::EDIT_OPERATIONS), "You may not view or edit an operation that does not involve your crew."])
  end
  before_filter(:only => :destroy_login) { |c| c.require_self_or_permission nil}

  def require_self_or_permission(necessary_auths)
    # If the current user does NOT have a current_crew, then he may only access his own attributes (certificates/qualifications/enrollments/etc)
    # (because we can't determine if he's on the same crew as the owner)
    # OTHERWISE
    # Current user must be on same crew as the owner of the attributes AND have the correct authorizations (i.e. EDIT_CERTIFICATES, etc) OR
    # Current user must be accessing his own attributes
    if current_person.current_crew.nil? or Person.find(params[:id]).current_or_most_recent_crew.nil?
      enforce(current_person.id == params[:id].to_i)
    else
      enforce((current_person.current_crew.id == Person.find(params[:id]).current_or_most_recent_crew.id &&
                        current_person.has_authorization?(necessary_auths)) ||
                        current_person.id == params[:id].to_i ||
                        current_person.account_type == "global_admin")
    end
  end

  # GET admin/people
  # GET admin/people.xml
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
  end

  # GET admin/people/1
  # GET admin/people/1.xml
  def show
    @person = Person.find(params[:id])
    @enrollments = Enrollment.joins(:scheduled_course).find_all_by_person_id(params[:id],:conditions => ["date_start >= ? or date_start IS NULL",Date.today.to_s],:order => "date_start")
    @certificates = Certificate.find_all_by_person_id(params[:id], :order => :name)
    @qualifications = Qualification.find_all_by_person_id(params[:id], :order => :acronym)

    # current_person will be designated as a 'certificate_admin' under the following conditions:
    #   - Current person is accessing their own certificates
    #   - Current person is currently a member of the same crew as the requested person
    #   - Current person is currently a member of the requested person's most recent crew (if the requested person has no current crew)
    @certificate_admin = ((@person.id == current_person.id) or 
                          (current_person.has_authorization?(Authorizations::EDIT_CERTIFICATES) and
                            current_person.current_crew.nil? ? false : current_person.current_crew.id == @person.current_or_most_recent_crew.id))
    # current_pseron will be designated as a 'qualification_admin' under the same conditions as 'certificate_admin' (except with the appropriate authorizations)
    @qualification_admin = ((@person.id == current_person.id) or
                          (current_person.has_authorization?(Authorizations::EDIT_QUALIFICATIONS) and
                            current_person.current_crew.nil? ? false : current_person.current_crew.id == @person.current_or_most_recent_crew.id))
    # current_person will be designated as an 'enrollment_admin' under the same conditions as 'certificate_admin' (except with the appropriate authorizations)
    @enrollment_admin = ((@person.id == current_person.id) or
                          (current_person.has_authorization?(Authorizations::EDIT_ENROLLMENTS) and
                            current_person.current_crew.nil? ? false : current_person.current_crew.id == @person.current_or_most_recent_crew.id))
    @operation_admin = @person.has_authorization?(Authorizations::EDIT_OPERATIONS)
    
    # If specified year is NOT VALID (and within a sensible range) then use the current year
    @year = (!params[:year].blank? and params[:year].scan(/\D/).empty? and (2000..2100).include?(params[:year].to_i)) ? params[:year]:Date.today.year

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET admin/people/new
  # GET admin/people/new.xml
  def new
    @person = Person.new
    #@roster is just to generate a redirect path after the new person is saved
    @roster = Roster.find(params[:roster_id]) unless params[:roster_id].nil?
    unless params[:name].nil?
      name = params[:name].split(" ")
      @person.firstname = name[0..name.length-2].join(" ")
      @person.lastname = name.last if name.length > 1
    end
    @person.account_type = 'guest'
    @show_email_field = true
    @show_password_field = false

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET admin/people/1/edit
  def edit
    @person = Person.find(params[:id])
    @roster = nil #This is used by the Person#new form to redirect back to the correct roster.
    if @person == current_person #Editing your own account
      @show_email_field = true
      @show_password_field = true
      @show_password_reset = false
      @show_account_type = false
      @show_destroy = true
    elsif @person.encrypted_password.blank? #Account is not your own, password DOES NOT EXIST
      @show_email_field = true
      @show_password_field = false
      @show_password_reset = false
      @show_account_type = false
      @show_destroy = false
    else #Account is not your own, password EXISTS
      @show_email_field = true
      @show_password_field = false
      @show_password_reset = true
      @show_account_type = true
      @show_destroy = false
    end
  end

  # GET admin/people/1/certificates
  def certificates
    @person = Person.find(params[:id])
    @certificates = Certificate.find_all_by_person_id(params[:id], :order => :name)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @certificates }
    end
  end

  # GET admin/people/1/qualifications
  def qualifications
    @person = Person.find(params[:id])
    @qualifications = Qualification.find_all_by_person_id(params[:id], :order => :acronym)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @qualifications }
    end
  end

  # GET admin/people/1/operations
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

  # GET admin/people/1/enrollments
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

  # POST admin/people
  # POST admin/people.xml
  def create
    @person = Person.new(params[:person])
    @person.authorizations = Authorizations.send("for_#{params[:person][:account_type]}")
    @show_email_field = true
    @show_password_field = false
    @show_password_reset = false
    @show_account_type = false
    #If @roster is defined, user should be redirected back to this roster after save is complete
    @roster = Roster.find(params[:roster_id]) unless params[:roster_id].nil?

    respond_to do |format|
      if @person.save
        unless @roster.blank?
          @new_rp = RosteredPerson.new(:person_id => @person.id, :roster_id => @roster.id)
          @new_rp.save
        end
        format.html { 
          redirect_to roster_for_admin_crew_url(@roster.crew.id,@roster.year), :notice => 'Person was successfully created.' and return unless params[:roster_id].blank?
          redirect_to :back, :notice => 'Person was successfully created.'
          }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT admin/people/1
  # PUT admin/people/1.xml
  def update
    @person = Person.find(params[:id])

    # Check to see if the new attributes look like a duplicate of an existing person.
    # Two people will be merged if their IQCS numbers AND Last Name are the same.
    #@person.locate_and_merge_duplicates
    
    # Allow changing a person's attributes without changing their password
    params[:person].delete(:password) if params[:person][:password].blank?

    old_authorizations = @person.authorizations
    @person.authorizations=Authorizations.send("for_#{params[:person][:account_type]}")
    @person.save
    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html {
          reset_password(@person.username) ? msg = " and password was reset" : msg = "" if(params[:reset_password] == "1")
          redirect_to(admin_person_url(@person), :notice => "Person was successfully updated#{msg}.")
        }
        format.xml  { head :ok }
      else
        @person.authorizations=(old_authorizations)
        @person.save
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # no route exists
  def reset_password(email)
    # This method also exists in the (non-admin)PeopleController
    @person = Person.find_by_username(email)
    @new_password = Person.generate_random_password

    if(@person && @person.password = @new_password)
        NatrapMailer.password_reset_email(@person,@new_password).deliver
        return true
    end
    return false
  end

  # DELETE admin/people/1
  # DELETE admin/people/1.xml
  def destroy
    # This method destroys a Person object and should only be used if no records
    # in the system refer to this Person. The :destroy_login method can be used
    # to strip the login credentials from a Person without destroying the entire
    # record.
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end

  # POST admin/people/1
  # POST admin/people/1.xml
  def destroy_login
    # This method strips the login credentials from a Person object, but leaves
    # the record otherwise intact.  This allows the deletion of a person's
    # login account without destroying the entire Person altogether.
    @person = Person.find(params[:id])
    @me = current_person
    @person.username = nil
    @person.password = nil
    @person.salt = nil

    respond_to do |format|
      if @person.save
        format.html {
          redirect_to(logout_url) and return if @person == @me
          redirect_to(:back)
          }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def to_xml
    super(:only => [:salt, :encrypted_password])
  end
end

class Admin::QualificationsController < ApplicationController
  before_filter :require_login
  before_filter :except => [:create, :new, :show] do |c|
    # Qualification must belong to the current user OR
    # Qualification must belong to a crewmember of the current user AND current user must have EDIT QUALIFICATIONS auth
    c.send(:enforce, ((current_person.current_crew.id == Qualification.find(params[:id]).person.current_crew.id) &&
                       current_person.has_authorization?(Authorizations::EDIT_QUALIFICATIONS)) ||
                       current_person.id == Qualification.find(params[:id]).person.id)
  end
  before_filter :only => [:new] do |c|
    # Current user must be on same crew as the owner of the qualification AND have EDIT_QUALIFICATIONS auth OR
    # Current user must own the new qualification
    c.send(:enforce, (current_person.current_crew.id == Person.find(params[:person_id]).current_crew.id &&
                      current_person.has_authorization?(Authorizations::EDIT_QUALIFICATIONS)) ||
                      current_person.id == params[:person_id].to_i)
  end
  before_filter :only => [:create] do |c|
    # Current user must be on same crew as the owner of the qualification AND have EDIT_QUALIFICATIONS auth OR
    # Current user must own the new qualification
    c.send(:enforce, (current_person.current_crew.id == Person.find(params[:qualification][:person_id]).current_crew.id &&
                      current_person.has_authorization?(Authorizations::EDIT_QUALIFICATIONS)) ||
                      current_person.id == params[:qualification][:person_id].to_i)
  end
  before_filter :only => :show do |c|
    # Current user must be on same crew as the owner of the qualification AND have VIEW_QUALIFICATIONS or EDIT_QUALIFICATIONS auth OR
    # Current user must own the new qualification
    c.send(:enforce, (current_person.current_crew.id == Qualification.find(params[:id]).person.current_crew.id &&
                      current_person.has_authorization?(Authorizations::VIEW_QUALIFICATIONS, Authorizations::EDIT_QUALIFICATIONS)) ||
                      current_person.id == Qualification.find(params[:id]).person.id)
  end

=begin
  # GET /qualifications
  # GET /qualifications.xml
  def index
    @qualifications = Qualification.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @qualifications }
    end
  end
=end

  # GET /qualifications/1
  # GET /qualifications/1.xml
  def show
    @qualification = Qualification.find(params[:id])
    @person = @qualification.person

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @qualification }
    end
  end

  # GET /qualifications/new
  # GET /qualifications/new.xml
  def new
    @qualification = Qualification.new
    @person = Person.find(params[:person_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @qualification }
    end
  end

  # GET /qualifications/1/edit
  def edit
    @qualification = Qualification.find(params[:id])
    @person = @qualification.person
  end

  # POST admin/qualifications
  # POST admin/qualifications.xml
  def create
    @qualification = Qualification.new(params[:qualification])

    respond_to do |format|
      if @qualification.save
        format.html { redirect_to(admin_qualification_url(@qualification), :notice => 'Qualification was successfully added.') }
        format.xml  { render :xml => @qualification, :status => :created, :location => @qualification }
      else
        format.html do
          @person = Person.find(params[:person_id])
          render :action => "new"
        end
        format.xml  { render :xml => @qualification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /qualifications/1
  # PUT /qualifications/1.xml
  def update
    @qualification = Qualification.find(params[:id])

    respond_to do |format|
      if @qualification.update_attributes(params[:qualification])
        format.html { redirect_to(admin_qualification_url(@qualification), :notice => 'Qualification was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @qualification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /qualifications/1
  # DELETE /qualifications/1.xml
  def destroy
    @qualification = Qualification.find(params[:id])
    @owner = @qualification.person
    @qualification.destroy

    respond_to do |format|
      format.html { redirect_to(qualifications_for_admin_person_url(@owner)) }
      format.xml  { head :ok }
    end
  end
end
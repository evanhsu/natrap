class Admin::CertificatesController < ApplicationController
  before_filter :require_login
  before_filter :except => [:create, :new, :show] do |c|
    # Certificate must belong to the current user OR
    # Certificate must belong to a crewmember of the current user AND current user must have EDIT CERTIFICATES auth
    c.send(:enforce, ((current_person.current_crew.id == Certificate.find(params[:id]).person.crew.id) &&
                       current_person.has_authorization?(Authorizations::EDIT_CERTIFICATES)) ||
                       current_person.id == Certificate.find(params[:id]).person.id)
  end
  before_filter :only => :new do |c|
    # Current user must be on same crew as the owner of the certificate AND have EDIT_CERTIFICATES auth OR
    # Current user must own the new certificate
    c.send(:enforce, (current_person.current_crew.id == Person.find(params[:person_id]).crew.id &&
                      current_person.has_authorization?(Authorizations::EDIT_CERTIFICATES)) ||
                      current_person.id == params[:person_id].to_i)
  end
  before_filter :only => :create do |c|
    # Current user must be on same crew as the owner of the certificate AND have EDIT_CERTIFICATES auth OR
    # Current user must own the new certificate
    c.send(:enforce, (current_person.current_crew.id == Person.find(params[:certificate][:person_id]).crew.id &&
                      current_person.has_authorization?(Authorizations::EDIT_CERTIFICATES)) ||
                      current_person.id == params[:certificate][:person_id].to_i)
  end
  before_filter :only => :show do |c|
    # Current user must be on same crew as the owner of the certificate AND have VIEW_CERTIFICATES or EDIT_CERTIFICATES auth OR
    # Current user must own the certificate
    c.send(:enforce, (current_person.current_crew.id == Certificate.find(params[:id]).person.crew.id &&
                      current_person.has_authorization?(Authorizations::VIEW_CERTIFICATES, Authorizations::EDIT_CERTIFICATES)) ||
                      current_person.id == Certificate.find(params[:id]).person.id)
  end

=begin
  # GET /certificates
  # GET /certificates.xml
  def index
    @certificates = Certificate.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @certificates }
    end
  end
=end

  # GET admin/certificates/1
  # GET admin/certificates/1.xml
  def show
    @certificate = Certificate.find(params[:id])
    @person = @certificate.person

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @certificate }
    end
  end

  # GET /certificates/new
  # GET /certificates/new.xml
  def new
    @certificate = Certificate.new
    @person = Person.find(params[:person_id])
    @url = admin_person_certificates_url(@person)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @certificate }
    end
  end

  # GET /certificates/1/edit
  def edit
    @certificate = Certificate.find(params[:id])
    @person = @certificate.person
    @url = admin_certificates_url(@certificate)
  end

  # POST /certificates
  # POST /certificates.xml
  def create
    @certificate = Certificate.new(params[:certificate])

    respond_to do |format|
      if @certificate.save
        format.html { redirect_to([:admin,@certificate], :notice => 'Certificate was saved!') }
        format.xml  { render :xml => @certificate, :status => :created, :location => @certificate }
      else
        format.html do
          @person = Person.find(params[:certificate][:person_id])
          render :action => "new"
        end
        format.xml  { render :xml => @certificate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /certificates/1
  # PUT /certificates/1.xml
  def update
    @certificate = Certificate.find(params[:id])

    respond_to do |format|
      if @certificate.update_attributes(params[:certificate])
        format.html { redirect_to(@certificate, :notice => 'Certificate was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @certificate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /certificates/1
  # DELETE /certificates/1.xml
  def destroy
    @certificate = Certificate.find(params[:id])
    @certificate_owner = @certificate.person
    @certificate.destroy

    respond_to do |format|
      format.html { redirect_to(certificates_for_admin_person_url(@certificate_owner)) }
      format.xml  { head :ok }
    end
  end
end
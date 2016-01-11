class CertificatesController < ApplicationController
  before_filter :require_login
  before_filter do |c|
    # Current user must be on same crew as the owner of the certificate AND have VIEW_CERTIFICATES or EDIT_CERTIFICATES auth OR
    # Current user must own the new certificate
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

  # GET /certificates/1
  # GET /certificates/1.xml
  def show
    @certificate = Certificate.find(params[:id])
    @person = @certificate.person
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @certificate }
    end
  end

  def download_attachment
    @certificate = Certificate.find(params[:id])
    send_file(@certificate.image.path, :type => @certificate.image.content_type, :disposition => "attachment")
  end

  def view_attachment
    @certificate = Certificate.find(params[:id])
    send_file(@certificate.image.path, :type => @certificate.image.content_type, :disposition => "inline")
  end
end
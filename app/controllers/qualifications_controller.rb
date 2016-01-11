class QualificationsController < ApplicationController
  before_filter :require_login
  before_filter :except => :autocomplete do |c|
    # Current user must be on same crew as the owner of the qualification AND have VIEW_QUALIFICATIONS or EDIT_QUALIFICATIONS auth OR
    # Current user must own the new qualification
    c.send(:enforce, (current_person.current_crew.id == Qualification.find(params[:id]).person.crew.id &&
                      current_person.has_authorization?(Authorizations::VIEW_QUALIFICATIONS, Authorizations::EDIT_QUALIFICATIONS)) ||
                      current_person.id == Qualification.find(params[:id]).person.id)
  end


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

  def download_attachment
    @qualification = Qualification.find(params[:id])
    send_file(@qualification.document.path, :type => @qualification.document.content_type, :disposition => "attachment")
  end

  def view_attachment
    @qualification = Qualification.find(params[:id])
    send_file(@qualification.document.path, :type => @qualification.document.content_type, :disposition => "inline") unless @qualification.document.blank?
  end

  def autocomplete
    @qualifications = Qualification.select("DISTINCT(acronym), description").where(["acronym LIKE ?", "%#{params[:query].strip}%"]).order("acronym")
    response = {
      :query => params[:query],
      :suggestions => @qualifications.map { |q| q.acronym },
      :data => @qualifications.map { |q| q.description }
    }

    respond_to do |format|
      format.json { render :json => response.to_json }
    end
  end
end
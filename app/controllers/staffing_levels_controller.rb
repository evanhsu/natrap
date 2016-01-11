class StaffingLevelsController < ApplicationController

  # GET /staffing_levels
  def index
    Time.zone = "America/Los_Angeles"

    if params[:history].blank?
      #Pick the most recent entry from each crew
      @staffing_levels = StaffingLevel.select("DISTINCT ON(crew_id) *").order(:crew_id, created_at: :desc)
    else
      #If a query parameter was passed, use it to retrieve a historical entry ("/staffing_levels?history=7" gets entries from 7 days ago)
      d = Date.today - (params[:history].to_i.days)
      #@staffing_levels = StaffingLevel.find(:all, :conditions => ["created_at <= ?", d], :group => :crew_id, :order => :crew_id )
      @staffing_levels = StaffingLevel.select("DISTINCT ON(crew_id) *").where("created_at <= ?", d).order(:crew_id, created_at: :desc)
    end

    @history = params[:history]

    respond_to do |format|
      format.html
      format.xml { render :xml => @staffing_levels }
    end
  end

end

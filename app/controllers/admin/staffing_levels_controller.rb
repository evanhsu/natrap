class Admin::StaffingLevelsController < ApplicationController

  # GET /admin/staffing_levels
  def index
    Time.zone = "America/Los_Angeles"

    if params[:history].blank?
      @staffing_levels = StaffingLevel.find(:all, :group => :crew_id, :order => :crew_id )
    else
      d = Date.today - (params[:history].to_i.days)
      @staffing_levels = StaffingLevel.find(:all, :conditions => ["created_at <= ?", d], :group => :crew_id, :order => :crew_id )
    end

    @history = params[:history]

    respond_to do |format|
      format.html
      format.xml { render :xml => @staffing_levels }
    end
  end

end
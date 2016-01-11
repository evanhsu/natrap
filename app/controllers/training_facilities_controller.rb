class TrainingFacilitiesController < ApplicationController
  before_filter :require_login
  before_filter :require_global_admin

  # GET /training_facilities
  # GET /training_facilities.xml
  def index
    @training_facilities = TrainingFacility.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @training_facilities }
    end
  end

  # GET /training_facilities/1
  # GET /training_facilities/1.xml
  def show
    @training_facility = TrainingFacility.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @training_facility }
    end
  end

  # GET /training_facilities/new
  # GET /training_facilities/new.xml
  def new
    @training_facility = TrainingFacility.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @training_facility }
    end
  end

  # GET /training_facilities/1/edit
  def edit
    @training_facility = TrainingFacility.find(params[:id])
  end

  # POST /training_facilities
  # POST /training_facilities.xml
  def create
    @training_facility = TrainingFacility.new(params[:training_facility])

    respond_to do |format|
      if @training_facility.save
        format.html { redirect_to(@training_facility, :notice => 'Training facility was successfully created.') }
        format.xml  { render :xml => @training_facility, :status => :created, :location => @training_facility }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @training_facility.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /training_facilities/1
  # PUT /training_facilities/1.xml
  def update
    @training_facility = TrainingFacility.find(params[:id])

    respond_to do |format|
      if @training_facility.update_attributes(params[:training_facility])
        format.html { redirect_to(@training_facility, :notice => 'Training facility was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @training_facility.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /training_facilities/1
  # DELETE /training_facilities/1.xml
  def destroy
    @training_facility = TrainingFacility.find(params[:id])
    @training_facility.destroy

    respond_to do |format|
      format.html { redirect_to(training_facilities_url) }
      format.xml  { head :ok }
    end
  end
end

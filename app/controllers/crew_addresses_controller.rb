class CrewAddressesController < ApplicationController
  # GET /crew_addresses
  # GET /crew_addresses.xml
  def index
    @crew_addresses = CrewAddress.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @crew_addresses }
    end
  end

  # GET /crew_addresses/1
  # GET /crew_addresses/1.xml
  def show
    @crew_address = CrewAddress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @crew_address }
    end
  end

  # GET /crew_addresses/new
  # GET /crew_addresses/new.xml
  def new
    @crew_address = CrewAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @crew_address }
    end
  end

  # GET /crew_addresses/1/edit
  def edit
    @crew_address = CrewAddress.find(params[:id])
  end

  # POST /crew_addresses
  # POST /crew_addresses.xml
  def create
    @crew_address = CrewAddress.new(params[:crew_address])

    respond_to do |format|
      if @crew_address.save
        format.html { redirect_to(@crew_address, :notice => 'Crew address was successfully created.') }
        format.xml  { render :xml => @crew_address, :status => :created, :location => @crew_address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @crew_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /crew_addresses/1
  # PUT /crew_addresses/1.xml
  def update
    @crew_address = CrewAddress.find(params[:id])

    respond_to do |format|
      if @crew_address.update_attributes(params[:crew_address])
        format.html { redirect_to(@crew_address, :notice => 'Crew address was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @crew_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /crew_addresses/1
  # DELETE /crew_addresses/1.xml
  def destroy
    @crew_address = CrewAddress.find(params[:id])
    @crew_address.destroy

    respond_to do |format|
      format.html { redirect_to(crew_addresses_url) }
      format.xml  { head :ok }
    end
  end
end

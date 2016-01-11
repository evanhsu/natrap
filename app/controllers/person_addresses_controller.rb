class PersonAddressesController < ApplicationController
  # GET /person_addresses
  # GET /person_addresses.xml
  def index
    @person_addresses = PersonAddress.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @person_addresses }
    end
  end

  # GET /person_addresses/1
  # GET /person_addresses/1.xml
  def show
    @person_address = PersonAddress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person_address }
    end
  end

  # GET /person_addresses/new
  # GET /person_addresses/new.xml
  def new
    @person_address = PersonAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person_address }
    end
  end

  # GET /person_addresses/1/edit
  def edit
    @person_address = PersonAddress.find(params[:id])
  end

  # POST /person_addresses
  # POST /person_addresses.xml
  def create
    @person_address = PersonAddress.new(params[:person_address])

    respond_to do |format|
      if @person_address.save
        format.html { redirect_to(@person_address, :notice => 'Person address was successfully created.') }
        format.xml  { render :xml => @person_address, :status => :created, :location => @person_address }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /person_addresses/1
  # PUT /person_addresses/1.xml
  def update
    @person_address = PersonAddress.find(params[:id])

    respond_to do |format|
      if @person_address.update_attributes(params[:person_address])
        format.html { redirect_to(@person_address, :notice => 'Person address was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person_address.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /person_addresses/1
  # DELETE /person_addresses/1.xml
  def destroy
    @person_address = PersonAddress.find(params[:id])
    @person_address.destroy

    respond_to do |format|
      format.html { redirect_to(person_addresses_url) }
      format.xml  { head :ok }
    end
  end
end

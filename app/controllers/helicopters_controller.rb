class HelicoptersController < ApplicationController
  # GET /helicopters
  # GET /helicopters.xml
  def index
    @helicopters = Helicopter.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @helicopters }
    end
  end

  # GET /helicopters/1
  # GET /helicopters/1.xml
  def show
    @helicopter = Helicopter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @helicopter }
    end
  end

  # GET /helicopters/new
  # GET /helicopters/new.xml
  def new
    @helicopter = Helicopter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @helicopter }
    end
  end

  # GET /helicopters/1/edit
  def edit
    @helicopter = Helicopter.find(params[:id])
  end

  # POST /helicopters
  # POST /helicopters.xml
  def create
    @helicopter = Helicopter.new(params[:helicopter])

    respond_to do |format|
      if @helicopter.save
        format.html { redirect_to(@helicopter, :notice => 'Helicopter was successfully created.') }
        format.xml  { render :xml => @helicopter, :status => :created, :location => @helicopter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @helicopter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /helicopters/1
  # PUT /helicopters/1.xml
  def update
    @helicopter = Helicopter.find(params[:id])

    respond_to do |format|
      if @helicopter.update_attributes(params[:helicopter])
        format.html { redirect_to(@helicopter, :notice => 'Helicopter was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @helicopter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /helicopters/1
  # DELETE /helicopters/1.xml
  def destroy
    @helicopter = Helicopter.find(params[:id])
    @helicopter.destroy

    respond_to do |format|
      format.html { redirect_to(helicopters_url) }
      format.xml  { head :ok }
    end
  end
end

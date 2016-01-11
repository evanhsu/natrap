class HelibasesController < ApplicationController
  # GET /helibases
  # GET /helibases.xml
  def index
    @helibases = Helibase.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @helibases }
    end
  end

  # GET /helibases/1
  # GET /helibases/1.xml
  def show
    @helibasis = Helibase.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @helibasis }
    end
  end

  # GET /helibases/new
  # GET /helibases/new.xml
  def new
    @helibasis = Helibase.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @helibasis }
    end
  end

  # GET /helibases/1/edit
  def edit
    @helibasis = Helibase.find(params[:id])
  end

  # POST /helibases
  # POST /helibases.xml
  def create
    @helibasis = Helibase.new(params[:helibasis])

    respond_to do |format|
      if @helibasis.save
        format.html { redirect_to(@helibasis, :notice => 'Helibase was successfully created.') }
        format.xml  { render :xml => @helibasis, :status => :created, :location => @helibasis }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @helibasis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /helibases/1
  # PUT /helibases/1.xml
  def update
    @helibasis = Helibase.find(params[:id])

    respond_to do |format|
      if @helibasis.update_attributes(params[:helibasis])
        format.html { redirect_to(@helibasis, :notice => 'Helibase was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @helibasis.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /helibases/1
  # DELETE /helibases/1.xml
  def destroy
    @helibasis = Helibase.find(params[:id])
    @helibasis.destroy

    respond_to do |format|
      format.html { redirect_to(helibases_url) }
      format.xml  { head :ok }
    end
  end
end

class DispatchCentersController < ApplicationController
  before_filter :require_login

  # GET /dispatch_centers
  # GET /dispatch_centers.xml
  def index
    prawnto :prawn => {
      :page_size => PdfSpecs::PAGE_SIZE, # (Handy Dandy page size)
      :margin => PdfSpecs::PAGE_MARGIN # Top, Right, Bottom, Left
    }
    @dispatch_centers = DispatchCenter.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dispatch_centers }
      format.pdf # index.pdf.prawn
    end
  end

  # GET /dispatch_centers/1
  # GET /dispatch_centers/1.xml
  def show
    @dispatch_center = DispatchCenter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dispatch_center }
    end
  end

  # GET /dispatch_centers/new
  # GET /dispatch_centers/new.xml
  def new
    @dispatch_center = DispatchCenter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dispatch_center }
    end
  end

  # GET /dispatch_centers/1/edit
  def edit
    @dispatch_center = DispatchCenter.find(params[:id])
  end

  # POST /dispatch_centers
  # POST /dispatch_centers.xml
  def create
    @dispatch_center = DispatchCenter.new(params[:dispatch_center])

    respond_to do |format|
      if @dispatch_center.save
        format.html { redirect_to(@dispatch_center, :notice => 'Dispatch center was successfully created.') }
        format.xml  { render :xml => @dispatch_center, :status => :created, :location => @dispatch_center }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dispatch_center.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dispatch_centers/1
  # PUT /dispatch_centers/1.xml
  def update
    @dispatch_center = DispatchCenter.find(params[:id])

    respond_to do |format|
      if @dispatch_center.update_attributes(params[:dispatch_center])
        format.html { redirect_to(dispatch_centers_path, :notice => 'Dispatch center was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dispatch_center.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dispatch_centers/1
  # DELETE /dispatch_centers/1.xml
  def destroy
    @dispatch_center = DispatchCenter.find(params[:id])
    @dispatch_center.destroy

    respond_to do |format|
      format.html { redirect_to(dispatch_centers_url) }
      format.xml  { head :ok }
    end
  end
end

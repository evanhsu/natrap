class CostSheetsController < ApplicationController
  # GET /cost_sheets
  # GET /cost_sheets.xml
  def index
    @cost_sheets = CostSheet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cost_sheets }
    end
  end

  # GET /cost_sheets/1
  # GET /cost_sheets/1.xml
  def show
    @cost_sheet = CostSheet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cost_sheet }
    end
  end

  # GET /cost_sheets/new
  # GET /cost_sheets/new.xml
  def new
    @cost_sheet = CostSheet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cost_sheet }
    end
  end

  # GET /cost_sheets/1/edit
  def edit
    @cost_sheet = CostSheet.find(params[:id])
  end

  # POST /cost_sheets
  # POST /cost_sheets.xml
  def create
    @cost_sheet = CostSheet.new(params[:cost_sheet])

    respond_to do |format|
      if @cost_sheet.save
        format.html { redirect_to(@cost_sheet, :notice => 'Cost sheet was successfully created.') }
        format.xml  { render :xml => @cost_sheet, :status => :created, :location => @cost_sheet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cost_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cost_sheets/1
  # PUT /cost_sheets/1.xml
  def update
    @cost_sheet = CostSheet.find(params[:id])

    respond_to do |format|
      if @cost_sheet.update_attributes(params[:cost_sheet])
        format.html { redirect_to(@cost_sheet, :notice => 'Cost sheet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cost_sheet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cost_sheets/1
  # DELETE /cost_sheets/1.xml
  def destroy
    @cost_sheet = CostSheet.find(params[:id])
    @cost_sheet.destroy

    respond_to do |format|
      format.html { redirect_to(cost_sheets_url) }
      format.xml  { head :ok }
    end
  end
end

class IrregularitiesController < ApplicationController
  before_action :set_irregularity, only: [:show, :edit, :update, :destroy]

  # GET /irregularities
  def index
    @irregularities = Irregularity.all

    respond_to do |format|
      format.html { render :index, :layout => 'welcome.html' } # index.html.erb
      format.xml  { render :xml => @irregularities }
    end
  end

  # GET /irregularities/1
  def show
    render :show, :layout => 'welcome.html'
  end

  # GET /irregularities/new
  def new
    @irregularity = Irregularity.new
    render :new, :layout => 'welcome.html'
  end

  # GET /irregularities/1/edit
  def edit
    render :edit, :layout => 'welcome.html'
  end

  # POST /irregularities
  def create
    @irregularity = Irregularity.new(irregularity_params)

    if @irregularity.save
      redirect_to @irregularity, notice: 'Irregularity was successfully created.'
    else
      render :new, :layout => 'welcome.html'
    end
  end

  # PATCH/PUT /irregularities/1
  def update
    if @irregularity.update(irregularity_params)
      redirect_to @irregularity, notice: 'Irregularity was successfully updated.'
    else
      render :edit, :layout => 'welcome.html'
    end
  end

  # DELETE /irregularities/1
  def destroy
    @irregularity.destroy
    redirect_to irregularities_url, notice: 'Irregularity was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_irregularity
      @irregularity = Irregularity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def irregularity_params
      params.require(:irregularity).permit(:date, :author, :fire_number, :fire_name, :tailnumber, :operation_id, :narrative)
    end
end

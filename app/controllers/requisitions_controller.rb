class RequisitionsController < ApplicationController
  before_action :set_requisition, only: [:show, :edit, :update, :destroy]

  # GET /requisitions
  def index
    @requisitions = Requisition.all
  end

  # GET /requisitions/1
  def show
  end

  # GET /crews/1/requisitions/new
  def new
    @crew = Crew.find(params[:crew_id])
    @requisition = Requisition.new
    #@requisition_line_items = []
    
    num_of_line_items = 8
    num_of_line_items.times do |i|
        # Create 8 blank line items for the NEW REQUISITION form
        #@requisition_line_items << RequisitionLineItem.new
         @requisition.requisition_line_items.build # Create new unsaved child objects
    end
  end

  # GET /requisitions/1/edit
  def edit
  end

  # POST /crews/1/requisitions
  def create
logger.debug requisition_params
    @requisition = Requisition.new(requisition_params)
    @crew = Crew.find(params[:crew_id])
    @requisition.crew_id = @crew.id
    @requisition.modified_by = current_person.fullname
logger.debug @requisition.inspect
    
    if @requisition.amount != @requisition.requisition_line_items.collect {|li| li.amount || 0}.sum #Add up the cost of all line items
        @requisition.valid? #Check the other validations too so a complete list is shown to the user
        @requisition.errors.add(:base, "The line item subtotals don't add up to the order total")
        render :new and return
    end

    if @requisition.save
      redirect_to requisitions_for_crew_path(@crew), notice: 'Requisition was successfully saved.'
    else
      render :new
    end
  end

  # PATCH/PUT /requisitions/1
  def update
    if @requisition.update(requisition_params)
      redirect_to @requisition, notice: 'Requisition was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /requisitions/1
  def destroy
    @requisition.destroy
    redirect_to requisitions_url, notice: 'Requisition was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_requisition
      @requisition = Requisition.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def requisition_params
      #Use the following line after the site is converted to use STRONG PARAMETERS and the 'protected_attributes' gem is removed
      #params.require(:requisition).permit(:vendor_info, :date, :description, :amount, :cardholder) 
      
      #This line is temporary solution to maintain compatibility with Rails 3.
      requisition_params = params[:requisition]
      #requisition_params["date"] = Date.strptime(requisition_params["date"],"%m/%d/%Y").strftime("%m/%d/%Y")
      #requisition_params
    end

    def requisition_line_items_params
      params[:requisition_line_items]
    end
end

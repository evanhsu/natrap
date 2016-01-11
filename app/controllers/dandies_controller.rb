class DandiesController < ApplicationController
  before_action :set_dandy, only: [:show, :edit, :update, :destroy]


  # GET /dandies
  def index
    @dandies = Dandy.all
  end

  # GET /dandies/1
  def show
    # @dandy already assigned by private#set_dandy

  end

  # GET /dandies/new
  def new
    @dandy = Dandy.new
  end

  # GET /dandies/1/edit
  def edit
  end

  # POST /dandies
  def create
    @dandy = Dandy.new(dandy_params)

    if @dandy.save
      redirect_to @dandy, notice: 'Dandy was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /dandies/1
  def update
    if @dandy.update(dandy_params)
      redirect_to @dandy, notice: 'Dandy was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /dandies/1
  def destroy
    @dandy.destroy
    redirect_to dandies_url, notice: 'Dandy was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dandy
      begin
        @dandy = Dandy.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        flash[:notice] = "Dandy \##{params[:id]} doesn't exist"
        redirect_to :action => 'index'
        return
      end
    end

    # Only allow a trusted parameter "white list" through.
    def dandy_params
      params[:dandy]
    end
end

class OperationsController < ApplicationController
  # GET /operations/1
  # GET /operations/1.xml
  def show
    @operation = Operation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @operation }
    end
  end
end

class RotationBoardController < ApplicationController
=begin
  # POST rotation_board
  # POST rotation_board.xml
  def create
    # This action is called whenever the rotation board is rearranged.
    # A new RoBoState is created and new RoBoPositions are created for each person on the list.
    # Ajax POST data format example:
    # [{
    #
    @state = RoBoState.new([params[:crew_id],params[:user_id],params[:username],params[:changeType],params[:changedPersonId]])

    respond_to do |format|
      if @state.save
        #format.json {}
        #format.html { , :notice => 'Board state saved' }
        #format.xml  { render :xml => @enrollment, :status => :created, :location => @enrollment }
      else
        #format.json {}
        #format.html { render :action => "new" }
        #format.xml  { render :xml => @enrollment.errors, :status => :unprocessable_entity }
      end
    end
  end
=end
  # GET rotation_board/378
  # GET rotation_board/378.json
  def show
    # This action can be called by AJAX scripts to retrieve a json object with the position of each person on the board.
    @state = RoBoState.find(params[:id]);
    @roBoPositions = @state.roBoPositions.order("listId,row")

    respond_to do |format|
      format.json { render :json => @roBoPositions }
    end
  end

# GET rotation_board/378/next.json
  def next
    # Finds the next roBoState for this crew that follows the specified roBoState chronologically 
    # and returns a json object with the position of each person.
    @state = RoBoState.find(params[:id]);
    @roBoPositions = @state.next().boardSnapshot
    
    respond_to do |format|
      format.json { render :json => @roBoPositions }
    end
  end

# GET rotation_board/378/previous.json
  def previous
    # Finds the previous roBoState for this crew that precedes the specified roBoState chronologically 
    # and returns a json object with the position of each person.
    @state = RoBoState.find(params[:id]);
    @roBoPositions = @state.previous().boardSnapshot
    
    respond_to do |format|
      format.json { render :json => @roBoPositions }
    end
  end

end

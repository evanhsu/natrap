class RoBoState < ActiveRecord::Base
  belongs_to :crew
  has_many :ro_bo_positions, :dependent => :destroy
  has_many :people, :through => :ro_bo_positions

  def create()
    @newState = RoBoState.create(RoBoState_params)
  end

  def next()
    #Returns the object with the next higher ID after the current object belonging to the same CREW
    RoBoState.where("(id > ?) AND (crew_id = ?)",self.id,self.crew_id).order("created_at ASC").try(:first)
  end

  def self.next(afterId)
    #Returns the next object after the one with the specified ID belonging to the same CREW.
    #RoBoState.where("id > ? && crew_id = ?",afterId,RoBoState.find(afterId).crew_id).order("created_at ASC").first
    RoBoState.find(afterID).try(:next) #This is more DRY, but requires 2 database queries 
  end

  def previous()
    #Returns the object with ID immediately preceding the current object and belonging to the same CREW
    RoBoState.where("id < ? AND crew_id = ?",self.id,self.crew_id).order("created_at DESC").try(:first)
  end

  def self.previous(beforeID)
    #Returns the object with ID immediately preceding the one with the specified ID and belonging to the same CREW
    #RoBoState.where("id < ? && crew_id = ?",beforeID,RoBoState.find(beforeId).crew_id).order("created_at DESC").first
    RoBoState.find(beforeID).try(:previous) #This is more DRY, but requires 2 database queries
  end

  def self.current_state_for_crew(crew_id)
    #Returns the most recent record for the specified CREW
    RoBoState.where({:crew_id => crew_id}).order(:created_at).last
  end

  def roBoPositions()
    #Override the default function - return the robopositions belonging to this roBoState, but make sure they are
    #in order by list and row.
    RoBoPosition.where(:roBoStateId => self.id).order("\"listId\" desc, \"row\" asc")
  end
 
  def boardSnapshot()
    #Provide the roBoPositions array bundled with the roBoState objects for both the requested state and the most recent state for this crew.
    #This is used by the javascript frontend to render the board and decide whether to activate the 'next' and 'previous' buttons, using
    #only 1 AJAX call.
    @pos = {}
    @pos[:positions] = self.roBoPositions
    #Include the CURRENT board state id to determine if this array is current or historical
    @pos[:currentRoBoState] = RoBoState.current_state_for_crew(self.crew_id)
    #Include the REQUESTED board state object to determine what change was made to the board to generate the requested state.
    @pos[:requestedRoBoState] = self
    @pos
  end

  def self.find_by_crew_and_date(crew_id,requested_date)
    #Find the first RoBoState on the requested date. If none exist for the requested date, find the last RoBoState
    # prior to this date.
    # requested_date is a Ruby Date object.
    @state = RoBoState.where({:crew_id => crew_id,:created_at => requested_date.beginning_of_day..requested_date.end_of_day}).order(:created_at).first
    @state.nil? ? RoBoState.where("crew_id = ? && created_at < ?",crew_id,requested_date).order(:created_at).last : @state
  end

  private
    # Using a private method to encapsulate the permissible parameters
    # is just a good pattern since you'll be able to reuse the same
    # permit list between create and update. Also, you can specialize
    # this method with per-user checking of permissible attributes.
    def RoBoState_params
      params.permit!
    end
end

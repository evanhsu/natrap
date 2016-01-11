class RosteredPersonController < ApplicationController

  # DELETE /rostered_person/1
  # DELETE /rostered_person/1.xml
  def destroy
    @roster = Roster.find(RosteredPerson.find(params[:id]).roster_id)
    @crew = Crew.find(@roster.crew_id)

    @rostered_person = RosteredPerson.find(params[:id])
    @rostered_person.destroy

    respond_to do |format|
      format.html { redirect_to(roster_for_admin_crew_url(@crew.id, @roster.year), :notice => 'Crewmember removed.') }
      format.xml  { head :ok }
    end
  end

end

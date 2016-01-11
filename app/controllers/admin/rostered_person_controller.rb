class Admin::RosteredPersonController < ApplicationController
  before_filter :require_login

  # DELETE /rostered_person/1
  # DELETE /rostered_person/1.xml
  def destroy
    #The NON-ADMIN controller is currently being used to perform the 'destroy' action (for no particular reason)
    @roster = Roster.find(RosteredPerson.find(params[:id]).roster_id)
    @crew = Crew.find(@roster.crew_id)

    @rostered_person = RosteredPerson.find(params[:id])
    @rostered_person.destroy
    
    respond_to do |format|
      format.html { redirect_to(roster_for_admin_crew_url(@crew.id, @roster.year), :notice => 'Crewmember removed.') }
      format.xml  { head :ok }
    end
  end

  def create
    @new_rostered_person = RosteredPerson.new(params[:rostered_person])
    @roster = Roster.find(params[:rostered_person][:roster_id])
    @crew = Crew.find(@roster.crew_id)


    respond_to do |format|
      if @new_rostered_person.save
        format.html { redirect_to(roster_for_admin_crew_url(@crew.id, @roster.year), :notice => 'Crewmember has been added!') }
        format.xml  { render :xml => @new_rostered_person, :status => :created, :location => roster_for_admin_crew_url(@crew.id, @roster.year) }
      else
        format.html do
          redirect_to(roster_for_admin_crew_url(@crew.id, @roster.year), :notice => 'Crewmember could not be added.')
        end
        format.xml  { render :xml => @new_rostered_person.errors, :status => :unprocessable_entity }
      end
    end

  end
end

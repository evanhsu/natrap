class PilotsController < ApplicationController
  def autocomplete
    @pilots = Pilot.joins('INNER JOIN people ON pilots.person_id = people.id').find(:all, :conditions => ["CONCAT(firstname, CONCAT(' ', lastname)) LIKE ?", "%#{params[:query].strip}%"])
    @pilots = @pilots.sort_by { |p| p.person.fullname }
    response = {
      :query => params[:query],
      :suggestions => @pilots.map { |p| p.person.fullname },
      :data => @pilots.map { |p| p.id } }

    respond_to do |format|
      format.json { render :json => response.to_json }
    end
  end
end

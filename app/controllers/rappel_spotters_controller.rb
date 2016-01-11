class RappelSpottersController < ApplicationController
  def autocomplete
    @spotters = RappelSpotter.joins('INNER JOIN people ON rappel_spotters.person_id = people.id').find(:all, :conditions => ["CONCAT(firstname, CONCAT(' ', lastname)) LIKE ?", "%#{params[:query].strip}%"])
    @spotters = @spotters.sort_by { |p| p.person.fullname }
    response = {
      :query => params[:query],
      :suggestions => @spotters.map { |p| p.person.fullname },
      :data => @spotters.map { |p| p.id } }

    respond_to do |format|
      format.json { render :json => response.to_json }
    end
  end
end

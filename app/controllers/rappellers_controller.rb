class RappellersController < ApplicationController
  def autocomplete
    @rappellers = Rappeller.joins('INNER JOIN people ON rappellers.person_id = people.id').find(:all, :conditions => ["CONCAT(firstname, CONCAT(' ', lastname)) LIKE ?", "%#{params[:query].strip}%"])
    @rappellers = @rappellers.sort_by { |p| p.person.fullname }
    response = {
      :query => params[:query],
      :suggestions => @rappellers.map { |p| p.person.fullname },
      :data => @rappellers.map { |p| p.id } }

    respond_to do |format|
      format.json { render :json => response.to_json }
    end
  end
end

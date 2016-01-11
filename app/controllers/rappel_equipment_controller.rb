class RappelEquipmentController < ApplicationController
  def autocomplete
    @equipment = Item::RappelEquipment.find(:all, :conditions => ["serial_number LIKE ? AND category LIKE ?", "%#{params[:query].strip}%", params[:category]])
    
    response = {
      :query => params[:query],
      :suggestions => @equipment.map { |e| e.serial_number }.sort,
      :data => @equipment.map { |e| e.serial_number }.sort }

    respond_to do |format|
      format.json { render :json => response.to_json }
    end
  end
end

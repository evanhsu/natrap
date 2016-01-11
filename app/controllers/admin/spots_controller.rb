class Admin::SpotsController < ApplicationController
  def update
    @spot = Spot.find(params[:id])
    @spot.attributes = params[:spot]
    @spot.set_confirmation(current_person)

    respond_to do |format|
      @spot.update_attributes(params[:spot])
      format.js
    end
  end

  def confirm
    @spot = Spot.find(params[:id])
    @spot.confirm(current_person)

    respond_to do |format|
      @spot.save
      format.js
    end
  end

  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy

    respond_to do |format|
      format.js
    end
  end
end

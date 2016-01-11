class Admin::RappelsController < ApplicationController
  before_filter :require_login
  before_filter do |c|
    c.send(:enforce, current_person.has_authorization?(Authorizations::EDIT_OPERATIONS))
  end
  before_filter :only => [:confirm] do |c|
    c.send(:enforce, current_person.current_crew == Rappel.find(params[:id]).rappeller.person.current_or_most_recent_crew)
  end
  before_filter :only => [:destroy, :update] do |c|
    c.send(:enforce, (current_person.current_crew == Rappel.find(params[:id]).rappeller.person.current_or_most_recent_crew) ||
                     (current_person.current_crew == Rappel.find(params[:id]).operation.crew))
  end
  before_filter :only => :create do |c|
    c.send(:enforce, current_person.current_crew == Operation.find(params[:rappel][:operation_id]).crew)
  end

  def create
    @rappel = Rappel.new(params[:rappel])
    @rappel.set_confirmation(current_person)
    @operation = Operation.find(params[:rappel][:operation_id])
    
    respond_to do |format|
      @rappel.save
      format.js
    end
  end

  def update
    @rappel = Rappel.find(params[:id])
    @rappel.attributes = params[:rappel]
    @rappel.set_confirmation(current_person)

    respond_to do |format|
      @rappel.save
      format.js
    end
  end

  def destroy
    @rappel = Rappel.find(params[:id])
    @rappel.destroy

    respond_to do |format|
      format.js
    end
  end

  def confirm
    @rappel = Rappel.find(params[:id])
    @rappel.confirm(current_person)

    respond_to do |format|
      @rappel.save
      format.js
    end
  end
end

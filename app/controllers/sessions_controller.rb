class SessionsController < ApplicationController
  def new
    if session[:current_person_id]
      redirect_to session[:intended_destination] and return unless session[:intended_destination].nil?
      redirect_to root_url
    else
      respond_to do |format|
        format.html # new.html.erb
      end
    end
  end
  
  def create
    if person = Person.authenticate(params[:person][:username], params[:person][:password])
      #Change session IDs to prevent session fixation attacks
      #change_session_id is defined in ApplicationController
      change_session_id
      session[:current_person_id] = person.id
      Person.find(session[:current_person_id]).current_crew.nil? ? flash[:alert] = "You haven't been assigned to a crew yet this year!":true
      redirect_to session[:intended_destination] unless session[:intended_destination].nil?
    end
    flash[:auth_alert] = "Your username or password was incorrect"
    redirect_to :back
  end

  def destroy
    reset_session
    flash[:notice] = "You have logged out"
    redirect_to root_url
  end
end

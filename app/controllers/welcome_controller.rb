class WelcomeController < ApplicationController
  def index
    @person = current_person
  end
end

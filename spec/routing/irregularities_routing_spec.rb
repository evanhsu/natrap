require "rails_helper"

RSpec.describe IrregularitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/irregularities").to route_to("irregularities#index")
    end

    it "routes to #new" do
      expect(:get => "/irregularities/new").to route_to("irregularities#new")
    end

    it "routes to #show" do
      expect(:get => "/irregularities/1").to route_to("irregularities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/irregularities/1/edit").to route_to("irregularities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/irregularities").to route_to("irregularities#create")
    end

    it "routes to #update" do
      expect(:put => "/irregularities/1").to route_to("irregularities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/irregularities/1").to route_to("irregularities#destroy", :id => "1")
    end

  end
end

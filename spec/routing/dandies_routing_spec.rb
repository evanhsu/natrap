require "rails_helper"

RSpec.describe DandiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/dandies").to route_to("dandies#index")
    end

    it "routes to #new" do
      expect(:get => "/dandies/new").to route_to("dandies#new")
    end

    it "routes to #show" do
      expect(:get => "/dandies/1").to route_to("dandies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/dandies/1/edit").to route_to("dandies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/dandies").to route_to("dandies#create")
    end

    it "routes to #update" do
      expect(:put => "/dandies/1").to route_to("dandies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/dandies/1").to route_to("dandies#destroy", :id => "1")
    end

  end
end

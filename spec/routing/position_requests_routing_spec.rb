require "spec_helper"

describe PositionRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/position_requests").should route_to("position_requests#index")
    end

    it "routes to #new" do
      get("/position_requests/new").should route_to("position_requests#new")
    end

    it "routes to #show" do
      get("/position_requests/1").should route_to("position_requests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/position_requests/1/edit").should route_to("position_requests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/position_requests").should route_to("position_requests#create")
    end

    it "routes to #update" do
      put("/position_requests/1").should route_to("position_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/position_requests/1").should route_to("position_requests#destroy", :id => "1")
    end

  end
end

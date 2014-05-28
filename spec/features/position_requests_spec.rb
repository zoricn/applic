require 'spec_helper'

describe "PositionRequests" do
  let(:position) {FactoryGirl.create(:position)}
  describe "GET /position_requests/new" do

    it "Submit the request", :js => true do
    	visit new_position_position_request_path(position.token)
      fill_in("position_request_email", :with => "office@kolosek.com")
      click_button("Apply")
    	expect(page).to have_content("Thank")
    end

    it "Submit the request", :js => true do
    	visit new_position_position_request_path(position.token)
      click_button("Apply")
    	#expect(page).to_not have_content("Thank")
    end
  end
end

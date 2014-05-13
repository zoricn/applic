require 'spec_helper'

describe "position_requests/index" do
  before(:each) do
    assign(:position_requests, [
      stub_model(PositionRequest,
        :position_id => 1,
        :applicant_id => 2,
        :status => 3,
        :token => "Token"
      ),
      stub_model(PositionRequest,
        :position_id => 1,
        :applicant_id => 2,
        :status => 3,
        :token => "Token"
      )
    ])
  end

  it "renders a list of position_requests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Token".to_s, :count => 2
  end
end

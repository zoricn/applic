require 'spec_helper'

describe "position_requests/show" do
  before(:each) do
    @position_request = assign(:position_request, stub_model(PositionRequest,
      :position_id => 1,
      :applicant_id => 2,
      :status => 3,
      :token => "Token"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/Token/)
  end
end

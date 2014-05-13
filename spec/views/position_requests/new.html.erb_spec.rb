require 'spec_helper'

describe "position_requests/new" do
  before(:each) do
    assign(:position_request, stub_model(PositionRequest,
      :position_id => 1,
      :applicant_id => 1,
      :status => 1,
      :token => "MyString"
    ).as_new_record)
  end

  it "renders new position_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", position_requests_path, "post" do
      assert_select "input#position_request_position_id[name=?]", "position_request[position_id]"
      assert_select "input#position_request_applicant_id[name=?]", "position_request[applicant_id]"
      assert_select "input#position_request_status[name=?]", "position_request[status]"
      assert_select "input#position_request_token[name=?]", "position_request[token]"
    end
  end
end

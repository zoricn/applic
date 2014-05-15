require 'spec_helper'

describe "attachments/index" do
  before(:each) do
    assign(:attachments, [
      stub_model(Attachment,
        :position_request_id => 1,
        :file => "File"
      ),
      stub_model(Attachment,
        :position_request_id => 1,
        :file => "File"
      )
    ])
  end

  it "renders a list of attachments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "File".to_s, :count => 2
  end
end

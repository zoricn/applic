require 'spec_helper'

describe "attachments/show" do
  before(:each) do
    @attachment = assign(:attachment, stub_model(Attachment,
      :position_request_id => 1,
      :file => "File"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/File/)
  end
end

require 'spec_helper'

describe "applicants/show" do
  before(:each) do
    @applicant = assign(:applicant, stub_model(Applicant,
      :first_name => "First Name",
      :last_name => "Last Name",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Email/)
  end
end

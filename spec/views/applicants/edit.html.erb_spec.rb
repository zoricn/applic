require 'spec_helper'

describe "applicants/edit" do
  before(:each) do
    @applicant = assign(:applicant, stub_model(Applicant,
      :first_name => "MyString",
      :last_name => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit applicant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", applicant_path(@applicant), "post" do
      assert_select "input#applicant_first_name[name=?]", "applicant[first_name]"
      assert_select "input#applicant_last_name[name=?]", "applicant[last_name]"
      assert_select "input#applicant_email[name=?]", "applicant[email]"
    end
  end
end

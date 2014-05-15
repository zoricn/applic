require 'spec_helper'

describe "attachments/new" do
  before(:each) do
    assign(:attachment, stub_model(Attachment,
      :position_request_id => 1,
      :file => "MyString"
    ).as_new_record)
  end

  it "renders new attachment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", attachments_path, "post" do
      assert_select "input#attachment_position_request_id[name=?]", "attachment[position_request_id]"
      assert_select "input#attachment_file[name=?]", "attachment[file]"
    end
  end
end

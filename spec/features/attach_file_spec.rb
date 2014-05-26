require 'spec_helper'

describe "'Attach file' form", :js => true do

    let(:current_user) { FactoryGirl.create(:user) }
    let(:position) { FactoryGirl.create(:position, :user => current_user) }
    let(:request) {FactoryGirl.create(:position_request,:position => position, :status => PositionRequest::STATUS_ACCEPTED)}

    before {login_as(current_user, :scope => :user)}

    context "the form that attaching file of unsupported type" do
      before(:each) do
        visit position_request_path(request.token)
        pending "Modal dialog present for unsupported format"
        #attach_file 'file', File.join(Rails.root, '/spec/fixtures/data_files/sample.jgv')
      end

      it 'attach the file to related document' do
        page.should_not have_content 'sample.jgv'
        current_path.should == position_request_path(request.token)
      end
    end

    context "the form that attaching file to the related request" do
      before(:each) do
        visit position_request_path(request.token)
        attach_file 'file', File.join(Rails.root, '/spec/fixtures/data_files/sample.doc')
      end

      it 'attach the file to related document' do
        page.should have_content 'sample.doc'
        current_path.should == position_request_path(request.token)
        #Attachment.last.should exist(file: 'sample.doc')
      end

      # context "after uploading" do
      #   before(:each) do
      #     expect(page).to have_content 'sample.txt' # Wait while file will be loaded
      #   end

      #   it "shows 'Related to' on the show file page", js: true do
      #     data_file = Attachment.last(conditions: { file: 'sample.txt' })
      #     ensure_on data_file_path(data_file)
      #     file_related_to.should have_content(related_document.name)
      #   end
      # end
    end
end

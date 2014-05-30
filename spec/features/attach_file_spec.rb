require 'spec_helper'

describe "'Attach file' form", :js => true do

    let(:current_user) { FactoryGirl.create(:user) }
    let(:position) { FactoryGirl.create(:position, :user => current_user) }
    let(:request) {FactoryGirl.create(:position_request,:position => position, :status => PositionRequest::STATUS_ACCEPTED)}

    before {login_as(current_user, :scope => :user)}

    context "upload is available request is in process with one comment at least" do
      before {request.process!}
      before {FactoryGirl.create(:comment, :commentable => request, :comment => "Owner comment")}
      before {stub_request(:put, "https://applicant-dev.s3-eu-west-1.amazonaws.com/attachments/Zu0_llVmh6Cyu8gUQr1Uug/1/sample.doc").
        with(:body => "This is sample attachment",
             :headers => {'Authorization'=>'AWS AKIAJUR4JH57JHN5WPVA:r0WY67wNJmzbl8UFtWGeZO3Dfj0=', 'Cache-Control'=>'max-age=315576000', 'Content-Length'=>'25', 'Content-Type'=>'application/msword', 'Date'=>'Tue, 27 May 2014 09:05:48 +0000', 'Host'=>'applicant-dev.s3-eu-west-1.amazonaws.com:443', 'User-Agent'=>'fog/1.22.0', 'X-Amz-Acl'=>'public-read'}).
        to_return(:status => 200, :body => "", :headers => {}) }


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

      context "the form that attaching file to the related request", :js => true do
        before(:each) do
          visit position_request_path(request.token)

          find("#image").click
          #attach_file 'image', File.join(Rails.root, '/spec/fixtures/data_files/sample.doc')
          hidden_field = find('#file_upload', :visible => false)
          hidden_field.set File.join(Rails.root, '/spec/fixtures/data_files/sample.doc')
        end

        it 'attach the file to related document' do
          page.should have_content 'sample.doc'
          current_path.should == position_request_path(request.token)
          #request.attachments.count.should == 1 #.last.should exist(file: 'sample.doc')
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

end

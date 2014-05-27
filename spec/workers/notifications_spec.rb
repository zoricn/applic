require 'spec_helper'

describe Notifications do
  
  before { ActionMailer::Base.deliveries = [] }
  let(:position) {FactoryGirl.create(:position)}
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user, account: user.account) }
  let(:applicant) {{"email" => "office@kolosek.com"}}

  before { @request = PositionRequest.create!(position: position, applicant: applicant)}

  it 'should send an email when notifying applicant of request created' do
    ActionMailer::Base.deliveries.last.to.should == [applicant["email"]]
  end

  it "should not notify when it's processed" do
    @request.process!
    ActionMailer::Base.deliveries.count.should == 1
  end

  it "should notify when rejected" do
    @request.reject!
    ActionMailer::Base.deliveries.count.should == 2
    ActionMailer::Base.deliveries.last.to.should == [applicant["email"]]
  end
end

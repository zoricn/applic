require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

describe MailWorker do

  before { ActionMailer::Base.deliveries = [] }
  let(:position) {FactoryGirl.create(:position)}
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user, account: user.account) }
  let(:applicant) {{"email" => "office@kolosek.com"}}

  it 'should use sidekiq to queue the jobs' do
    expect {
      PositionRequest.create!(position: position, applicant: applicant)
    }.to change(MailWorker.jobs, :size).by(1)
  end

  it 'should send an email when notifying applicant of request created' do
    PositionRequest.create!(position: position, applicant: applicant)
    MailWorker.drain
    ActionMailer::Base.deliveries.last.to.should == [applicant["email"]]
  end

  context "on action" do
    before{@request = PositionRequest.create!(position: position, applicant: applicant)}

    it "should not notify when it's processed" do
      @request.process!
      MailWorker.drain
      ActionMailer::Base.deliveries.count.should == 1
    end

    it "should notify when rejected" do
      @request.reject!
      MailWorker.drain
      ActionMailer::Base.deliveries.count.should == 2
      ActionMailer::Base.deliveries.last.to.should == [applicant["email"]]
    end


    it "should notify when accepted" do
      @request.accept!
      MailWorker.drain
      ActionMailer::Base.deliveries.count.should == 2
      ActionMailer::Base.deliveries.last.to.should == [applicant["email"]]
    end

    it "should notify on first comment after process" do
      @request.process!
      FactoryGirl.create(:comment, :commentable => @request, :comment => "Owner comment")
      MailWorker.drain
      ActionMailer::Base.deliveries.count.should == 2
    end

    it "should notify on after first comment after process" do
      @request.process!
      FactoryGirl.create(:comment, :commentable => @request, :comment => "Owner comment")
      FactoryGirl.create(:comment, :commentable => @request, :comment => "Owner comment")
      MailWorker.drain
      ActionMailer::Base.deliveries.count.should == 2
    end

    it "should notify on comment even after accepted" do
      @request.accept!
      FactoryGirl.create(:comment, :commentable => @request, :comment => "Owner comment")
      MailWorker.drain
      ActionMailer::Base.deliveries.count.should == 3
    end


  end
end

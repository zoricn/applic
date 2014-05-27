require 'spec_helper'

describe "Commenting" do

  context "As signed in user" do

    let(:current_user) { FactoryGirl.create(:user) }

    before {login_as(current_user, :scope => :user)}


    describe "commenting" do

      before {@position = FactoryGirl.create(:position, :user => current_user)}
      before {@request = FactoryGirl.create(:position_request, :position => @position)}


      context "as part of position interviewer" do
        before {visit position_request_path(@request.token)}

        it "should submit the comment" do
          fill_in("comment_textarea", :with => "fill me in")
          click_button "Submit"
          within("#comment_textarea") do
            expect(page).to_not have_content("fill me in")
          end
        end

        it "should show written comment below" do
          fill_in("comment_textarea", :with => "fill me in")
          click_button "Submit"
          expect(page).to have_content("fill me in")
        end
      end

      context "as part of position interviewee" do
        before {logout}

        it "should not be able to submit the comment in pending state" do
          visit position_request_path(@request.token)
          expect(page).to_not have_button("Submit")
        end

        it "should not be able to submit if owner didn't comment first" do
          @request.process!
          visit position_request_path(@request.token)
          expect(page).to_not have_button("Submit")
        end

        it "should be able to submit if owner comment first" do
          @request.process!
          FactoryGirl.create(:comment, :commentable => @request, :comment => "Owner comment")
          visit position_request_path(@request.token)
          expect(page).to have_button("Submit")
        end

        it "should be able to submit if owner comment first" do
          @request.process!
          FactoryGirl.create(:comment, :commentable => @request, :comment => "Owner comment")
          visit position_request_path(@request.token)
          fill_in("comment_textarea", :with => "fill me in")
          click_button "Submit"
          within("#comment_textarea") do
            expect(page).to_not have_content("fill me in")
          end
          expect(page).to have_content("fill me in")
        end
      end
    end
  end
end

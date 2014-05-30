require 'spec_helper'

describe "Positions" do

  context "As signed in user" do

    let(:current_user) { FactoryGirl.create(:user) }

    before {login_as(current_user, :scope => :user)}

    describe "GET /" do
      it "should load root dashboard even when no positions added" do
        visit root_path
        expect(page).to have_content "New Position"
      end

    end

    describe "GET index" do

      before {@position = FactoryGirl.create(:position, :user => current_user)}
      before {visit root_path}

      it "Should list all positions" do
        expect(page).to have_content(@position.title)
      end

      context "show one position" do

        it "should show applied tab" do
          click_link @position.title
          expect(page).to have_content("Applied")
        end

        it "should show rejected tab" do
          click_link @position.title
          expect(page).to have_content("Rejected")
        end

        context "requests statuses" do

          before {@request = FactoryGirl.create(:position_request, :position => @position)}

          it "should show one pending status" do
            click_link @position.title
            click_link "Applied"
            expect(page).to have_content("pending")
            expect(page).to_not have_content("Status")
          end

          it "should show main chat screen" do
            click_link @position.title
            click_link "Applied"
            click_link "Process"
            expect(page).to have_content("Files")
            expect(page).to_not have_content("Status")
          end

          it "should remove request from the list" do
            click_link @position.title
            click_link "Process"
            click_link "Reject"
            expect(page).to_not have_content(@request.entity_email)
          end

        end

      end

    end
  end

  context "As not registered user" do
    before {visit root_path}

    it "Should not load positions" do
      expect(page).to_not have_content "New Position"
    end

    it "should show login screen" do
      click_login
      expect(page).to have_content "Sign in"
    end


  end
end

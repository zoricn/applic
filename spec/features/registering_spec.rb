require 'spec_helper'

describe "Users" do

  context "As not registered user" do
    before {visit root_path}
    before {create(:user, :email => "john@doe.com")}

    it "Should not load positions" do
      expect(page).to_not have_content "New Position"
    end

    it "should show login screen" do
      click_login
      expect(page).to have_content "Sign in"
    end

    it "should sign in successfully" do
      click_login
      fill_in("Email", :with => "john@doe.com")
      fill_in("Password", :with => "password")
      click_sign_in
      expect(page).to have_content(logout_link)
    end


    it "should not sign in successfully" do
      click_login
      fill_in("Email", :with => "john1@doe.com")
      fill_in("Password", :with => "password")
      click_sign_in
      expect(page).to_not have_content(logout_link)
    end
  end
end

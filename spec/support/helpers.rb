module NavigationHelpers
  def click_picker
    page.find("#picker").click
  end

  def click_login
    click_link "Login"
  end

  def click_sign_in
    click_button "Sign in"
  end

  def sign_out
    click_link "Signout"
  end

  def click_new_position
    click_link "New Position"
  end

end

module ContentHelpers
  def should_sho_popup(asset_id = nil)
    page.should have_content("Load Profile")
  end

end

module SectionHelpers
  def logout_link
    "Sign out"
  end
end

module UserHelpers
  def registered_user(email)
    @user = FactoryGirl.build(:user)
    @user.skip_confirmation!
    @user.save!
  end

  def authenticated_user
    registered_user('user@example.org')
    visit('/')
    fill_in("user_email", :with => @user.email )
    fill_in("user_password", :with => "password")
    click_button("Log In")
    # page.should have_content("Signed in successfully.")
  end

  def select_date(year, month, day)
    select(year, :from => "user_date_of_birth_1i")
    select(month, :from => "user_date_of_birth_2i")
    select(day, :from => "user_date_of_birth_3i")
  end
end

include NavigationHelpers
include SectionHelpers
include ContentHelpers
include UserHelpers
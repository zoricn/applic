include Warden::Test::Helpers
 
module FeatureMacros

  def login_user
  	before(:each) do
      @user = FactoryGirl.create(:user)
      login_as @user, :scope => :user
    end
  end

end

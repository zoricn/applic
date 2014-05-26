module ControllerMacros

  def it_should_require_signed_in_user_for_actions(*actions)
      actions = controller_class.action_methods if actions.first == :all
      actions.delete("missing_route")
      actions.each do |action|
        it "#{action} action should require signed in user" do
          #as_signed_out_visitor
          get action.to_sym, :id => 1
          response.should redirect_to(new_user_session_path)
          #flash[:alert].should eql(I18n.t('messages.must_be_signed_in'))
        end
      end
  end
end
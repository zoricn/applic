describe PositionPolicy do
  subject { PositionPolicy }

  context "for a user" do

    context "who is owner" do

      let(:current_user) { FactoryGirl.create(:user) }
      let(:position) {FactoryGirl.create(:position, :user => current_user)}
      permissions :update? do
        it { expect(subject).to permit(current_user, position) }
      end
      permissions :create? do
        it { expect(subject).to permit(current_user, position) }
      end
      permissions :new? do
        it { expect(subject).to permit(current_user, position) }
      end
      permissions :destroy? do
        it { expect(subject).to permit(current_user, position) }
      end
      permissions :show? do
        it { expect(subject).to permit(current_user, position) }
      end
    end

    context "who is not owner" do

      let(:current_user) { FactoryGirl.create(:user) }
      let(:position) {FactoryGirl.create(:position)}
      permissions :update? do
        it { expect(subject).not_to permit(current_user, position) }
      end
      permissions :create? do
        it { expect(subject).to permit(current_user, position) }
      end
      permissions :new? do
        it { expect(subject).to permit(current_user, position) }
      end
      permissions :destroy? do
        it { expect(subject).not_to permit(current_user, position) }
      end
      permissions :show? do
        it { expect(subject).not_to permit(current_user, position) }
      end
    end

  end
end

class PositionPolicy < ApplicationPolicy
    attr_reader :user,  # User performing the action
              :record # Instance upon which action is performed

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def show?   ; record.is_owner? user; end
  def create? ; true; end
  def update? ; record.is_owner? user; end
  def destroy?; record.is_owner? user; end

end
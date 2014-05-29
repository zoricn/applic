class PositionPolicy < ApplicationPolicy

  def show?   ; record.is_owner? user; end
  def create? ; true; end
  def update? ; record.is_owner? user; end
  def destroy?; record.is_owner? user; end

end
class PagesController < ApplicationController
  layout 'dashboard'
  def index
    @positions = Position.all
  end

end

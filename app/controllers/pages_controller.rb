class PagesController < ApplicationController
  layout 'dashboard'
  def index
    @positions = current_user ? Position.all : []
  end

end

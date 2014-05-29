class PositionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_position, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, :except => [:index, :new]
  before_action :set_authorize_check, :except => [:index, :new] # This always follows the verify_authorized
  layout :resolve_layout

  # GET /positions
  def index
    @positions = current_user.positions
  end

  # GET /positions/1
  def show
      #raise NotAuthorizedError unless PositionPolicy.new(current_user, @position).show?
   authorize @position
    @requests = case params[:type]
    when "rejected"
       @position.position_requests.rejected.sort_by{|i| i.created_at}.reverse!
    when "accepted"
       @position.position_requests.accepted.sort_by{|i| i.created_at}.reverse!
    else
       @position.position_requests.open.sort_by{|i| i.created_at}.reverse!
    end
  end

  def new
    @position = Position.new
  end

  def edit
  end

  def create
    @position = Position.new(position_params)
    @position.user_id = current_user.id


    if @position.save
      redirect_to @position, notice: 'Position was successfully created.'
    else
      render :new
    end
  end

  def update
    if @position.update(position_params)
      redirect_to @position, notice: 'Position was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @position.destroy
    redirect_to positions_url, notice: 'Position was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def position_params
      params.require(:position).permit(:title, :description, :fields_attributes).tap do |whitelisted|
        whitelisted[:fields] = params[:position][:fields]
      end
    end

    def set_authorize_check
      authorize @position
    end

    def resolve_layout
      %w(new).include?(action_name) ? "application" : "dashboard"
    end
end

class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]
  layout :resolve_layout

  # GET /positions
  def index
    @positions = current_user.positions
    @open_positions = Position.all.where(:user_id != current_user.id )
    @open_positions -= @positions
    @applied_positions = []
  end

  # GET /positions/1
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions
  def create
    @position = Position.new(position_params)
    @position.user_id = current_user.id

    if @position.save
      redirect_to @position, notice: 'Position was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /positions/1
  def update
    if @position.update(position_params)
      redirect_to @position, notice: 'Position was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /positions/1
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
      params.require(:position).permit(:title, :description)
    end

    def resolve_layout
    case action_name
      when "index"
        "dashboard"
      else
        "dashboard"
      end
    end
end

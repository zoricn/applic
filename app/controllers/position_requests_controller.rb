class PositionRequestsController < ApplicationController
  before_action :get_position_request, only: [:accept, :reject]
  before_action :get_position, only: [:new, :create]
  before_action :get_position_protected, only: [:create]
  before_action :get_request_by_token, only: [:show, :status]
  before_action :already_applied?, only: [:new, :create]
  before_action :authorized?, only: [:accept, :reject] 

  def show
  end

  def new
    @position_request = @position.position_requests.build
    @attachment = @position_request.attachments.build
    render :layout => false
  end

  def create
    @position_request = @position.position_requests.build(position_request_params)
    @position_request.user_id = current_user.id if current_user

    if @position_request.save
       params[:attachments]['file'].each do |f|
          @attachment = @position_request.attachments.create!(:file => f, :position_request_id => @position_request.id)
       end unless params[:attachments].nil?
      redirect_to new_position_position_request_path(@position), notice: 'Position request was successfully created. Please wait email with details.'
    else
      render :new
    end
  end

  def accept
    @position_request.accept!
    redirect_to position_request_path(@position_request.token)
  end

  def reject
    @position_request.reject!
    redirect_to position_path(@position_request.position)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_position_request
      @position_request = PositionRequest.find(params[:id])
    end

    #### PLEASE REFACTOR THIS TWO METHODS!!!###

    def get_position
      @position = Position.find(params[:position_id])
    end

    def get_position_protected
      @position = Position.find(position_request_params[:position_id])
    end

    def already_applied?
     redirect_to root_path, notice: 'You already applied to this job' if @position.applied?(current_user)
    end

    def authorized?
      redirect_to root_path, notice: "You are not authorized to do that. This action has been logged you'll be banned if tried again" unless @position_request.authorized?(current_user)
    end

    def get_request_by_token
      @position_request = PositionRequest.find_by_token params[:token]   
    end

    # Only allow a trusted parameter "white list" through.
    def position_request_params
      params.require(:position_request).permit(:position_id, :first_name, :last_name, :email, attachments_attributes: [:id, :position_request_id, :file])
    end
end

class PositionRequestsController < ApplicationController
  before_filter :authenticate_user!, except: [:update, :new, :create, :show]
  before_action :get_position_request, only: [:accept, :reject, :update, :process_request, :archive]
  before_action :get_position_by_token, only: [:create, :update]
  before_action :get_request_by_token, only: [:show, :status]
  before_action :authorized?, only: [:accept, :reject, :process_request]

  layout :resolve_layout

  def show
    @position = @position_request.position
    @position_request.seen! unless current_user
  end

  def new
    @position = Position.find_by_token(params[:token])
    @position_request = @position.position_requests.build
    @attachment = @position_request.attachments.build
    render :layout => false
  end


  #REFACTOR: CREATE AND UPDATE ACTIONS
  def create
    @position_request = @position.position_requests.build(position_request_params)
    @position_request.user_id = current_user.id if current_user

    if @position_request.save
      save_files params[:attachments]
      redirect_to new_position_position_request_path(@position.token), notice: 'Position request was successfully created. Please wait email with details.'
    else
      redirect_to new_position_position_request_path(@position.token), notice: 'You already applied for this job. Please let others apply too.'
    end
  end

  def update
    if !params[:attachments].nil?
       save_files params[:attachments]
      respond_to do |format|
        format.html { redirect_to( position_request_path(@position_request.token), notice: 'Successfully added attachment. Thanks') }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to( position_request_path(@position_request.token), alert: 'There was nothing to attach.') }
        format.js
      end
    end
  end

  def accept
    @position_request.accept!
    redirect_to position_request_path(@position_request.token)
  end

  def process_request
    @position_request.process!
    redirect_to position_request_path(@position_request.token)
  end

  def reject
    @position_request.reject!
    redirect_to position_path(@position_request.position, :type => "reject")
  end

  def archive
    @position_request.archive!
    redirect_to position_path(@position_request.position, :type => "process")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def get_position_request
      @position_request = PositionRequest.find(params[:id])
    end

    def get_position_by_token
      @position = Position.find_by_token(position_request_params[:token])
    end

    def authorized?
      redirect_to root_path, notice: "You are not authorized to do that. This action has been logged you'll be banned if tried again" unless @position_request.authorized?(current_user)
    end

    def get_request_by_token
      @position_request = PositionRequest.find_by_token params[:token]
    end

    def save_files(attachment)
       attachment['file'].each do |f|
          @attachment = @position_request.attachments.create!(:file => f, :position_request_id => @position_request.id)
       end unless attachment.nil?
    end

    # Only allow a trusted parameter "white list" through.
    #REFACTOR: token is allowed, but also token is used to find position!!
    def position_request_params
      params.require(:position_request).permit(:token, attachments_attributes: [:id, :position_request_id, :file]).tap do |whitelisted|
        whitelisted[:applicant] = params[:position_request][:applicant]
      end
    end

    def resolve_layout
      %w(show).include?(action_name) ? "dashboard" : "application"
    end
end

class CommentsController < ApplicationController
  before_filter :authenticate_user!
  ## Commenting is allowed for non-registered users too
#before_filter :authenticate_user!   
before_action :get_record_commentable, only: [:create]
before_action :check_if_allowed, only: [:create]

def new
end
 
 #TODO: Refactor - Create.js as it updates one unexisting id - uses two different calls
 def create
  @comment = @record_commentable.comments.create(:commentable => @record_commentable, :user_id => current_user.try(:id), :comment => params[:comment][:comment] )
  #@comment.notify!
  #@comment.create_activity :create, owner: current_user, recipient: @idea
    respond_to do |format|
	      format.html { redirect_to( position_request_path(@record_commentable.token)) }
	      format.js
	  end
  end

  private

  def get_record_commentable
    model_name = params[:comment][:commentable_type]
    @record_commentable = model_name.constantize.find(params[:comment][:commentable_id])
  end

  def check_if_allowed
    redirect_to root_path, notice: 'This job request is now closed' if @record_commentable.status_closed?
  end
end
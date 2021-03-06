class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope -> { order('created_at ASC') }

  # NOTE: Comments belong to a user
  belongs_to :user

  after_create :notify!

  #If it's first comment notify the user he is been eleceted for further processing
  def notify!
    if self.commentable.comments.count > 1
      MailWorker.perform_async("CommentMailer", :comment_received, self.id)
    else
      MailWorker.perform_async("RequestMailer", :request_in_process, self.commentable.id)
    end
  end
end

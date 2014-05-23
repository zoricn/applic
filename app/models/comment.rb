class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope -> { order('created_at ASC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  after_create :notify!

  #If it's first comment notify the user he is been eleceted for further processing
  def notify!
    if self.commentable.comments.count > 1
      Notifications.comment_received(self)
    else
      Notifications.request_in_process(self.commentable)
    end
  end
end

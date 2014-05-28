class CommentMailer < ActionMailer::Base
  require 'mandrill'
  #include Sidekiq::Worker
  default :from => "\"Applicant\" <no-reply@kolosek.com>"
  

  def comment_received(comment_id)
    comment = Comment.find comment_id
    return if comment.user_id.nil? #Don't inform user owner
    @request = comment.commentable
    @email = @request.entity_email
    @comment = comment

    mail(to: @email, :subject => "Imate novu poruku u vezi sa vasom aplikacijom")
  end



end
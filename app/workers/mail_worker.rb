class MailWorker
  include Sidekiq::Worker

  # Change for comment
  def perform(klass, method, *args)
    mail = klass.constantize.send(method, *args)
    mail.deliver
  end
end
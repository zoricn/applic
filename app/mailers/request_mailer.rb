class RequestMailer < ActionMailer::Base
  require 'mandrill'
  #include Sidekiq::Worker
  default :from => "\"Applicant\" <no-reply@kolosek.com>"
  

  def request_received(request_id)
    request = PositionRequest.find request_id
    @email = request.entity_email
    @owner   = request.position.user
    @request = request

    mail(to: @email, :subject => "Hvala na prijavi")
  end

  def request_accepted(request_id)
    request = PositionRequest.find request_id
    @email = request.entity_email
    @owner   = request.position.user
    @request = request

    mail(to: @email, :subject => "Primljeni ste")
  end

  def request_in_process(request_id)
    request = PositionRequest.find request_id
    @email = request.entity_email
    @owner   = request.position.user
    @request = request

    mail(to: @email, :subject => "Vasa aplikacija je u procesu")
  end

  def request_rejected(request_id)
    request = PositionRequest.find request_id
    @email = request.entity_email
    @owner   = request.position.user
    @request = request

    mail(to: @email, :subject => "Nazalost vasa aplikacija je trenutno odbijena")
  end


end
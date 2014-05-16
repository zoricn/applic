class Notifications < ActionMailer::Base
  require 'mandrill'
  #include Sidekiq::Worker
  default :from => "\"Applicant\" <no-reply@kolosek.com>"
  

  def request_received(request)
    @email = request.entity_email
    @owner   = request.position.user
    @request = request

    mail(to: @email, :subject => "Hvala na prijavi").deliver
    begin
      # ADD email to the position owner!
    rescue Exception => e
      puts e
    end
  end

  def request_accepted(request)
    @email = request.entity_email
    @owner   = request.position.user
    @request = request

      mail(to: @email, :subject => "Pozvani ste na dalje korake").deliver 
    begin 
    rescue Exception => e
      
    end
  end

  def request_rejected(request)
    @email = request.entity_email
    @owner   = request.position.user
    @request = request

    mail(to: @email, :subject => "Nazalost vasa aplikacija je trenutno odbijena").deliver  
    begin
    rescue Exception => e
      
    end
  end

  def request_accepted_mandrill_template(request)
    entity = request.user
    owner   = request.position.user
    begin
      m = Mandrill::API.new(ENV['PEERIA_PASSWORD'])
      link = "<a href=\"#{user_path(entity, :only_path => false)}\" style=\"border:1px solid #a71784;background:#de15ae;color:white;width:30%;margin:10px auto;border-radius:3px;padding:16px;text-decoration:none;display:block\">go to Peeria</a>"
      template = m.templates.render "New Comments", [{:name => "link_to", :content => link}, {:first_name => "first_name", :content => entity.first_name}]
      mail_job = mail(:to => entity.email, :subject => "You have new comments") do |format|
         format.html { template['html'] }
         #format.text { render "test" }
      end
      mail_job.deliver
    rescue Exception => e
      puts e
    end
  end


end
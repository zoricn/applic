ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'smtp.mandrillapp.com',
  :port => 587,
  :domain => 'kolosek.com',
  :authentication => :plain,
  :user_name => ENV['PEERIA_EMAIL'],
  :password => ENV['PEERIA_PASSWORD']
}

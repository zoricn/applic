class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :resolve_layout

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, Net::SMTPAuthenticationError, with: lambda { |exception| render_error 404, exception }
  end

  # Exception handling

  def render404
    render :file => File.join(Rails.root, 'public', '404.html'), :status => 404, :layout => false
    return true
  end

  def render_error(status = 404, exception = nil)
    unless exception.nil?
      Rails.logger.error "#{exception.class} (#{exception.try(:message)})"
      exception.backtrace[0..10].each do |line|
        Rails.logger.error "    " + line
      end
    end

    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end

  def resolve_layout
    if !current_user.nil?
      'dashboard'
    else
      'application'
    end
  end  

end

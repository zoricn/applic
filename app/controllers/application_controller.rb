class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :resolve_layout

  def render404
    render :file => File.join(Rails.root, 'public', '404.html'), :status => 404, :layout => false
    return true
  end

    def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User)
      	positions_path
      else
        super
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

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  def after_sign_in_path_for(resource)
    if resource.is_a?(Teacher)
      teacher_dashboard_path  # Redirect teachers to their dashboard
    elsif resource.is_a?(Student)
      student_dashboard_path  # Redirect students to their dashboard
    else
      root_path # Default redirection
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :email, :password, :password_confirmation, :phone_number, :role ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :email, :password, :password_confirmation, :phone_number, :role ])
  end
end

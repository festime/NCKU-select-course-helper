class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :user_has_finished_necessary_settings?

  def user_has_finished_necessary_settings?
    session[:institute_code] &&
    session[:courses_id] &&
    session[:obligatory_courses_id]
  end
end

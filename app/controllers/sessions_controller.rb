class SessionsController < ApplicationController
  before_action :reject_user_has_set_personal_information, only: [:new, :create]

  def new
  end

  def create
    session[:institute_code] = params[:institute_code]
    session[:grade] = params[:grade]
    session[:class_name] = params[:class_name]
    #session[:user] = "#{params[:department]} #{params[:grade]} #{params[:class_name]}"
    redirect_to front_path
  end

  def destroy
    session[:institute_code] = session[:grade] = session[:class_name] = nil
    #session[:user] = nil
    redirect_to setting_path
  end

  private

  def reject_user_has_set_personal_information
    redirect_to front_path if session[:institute_code] && session[:grade]
    #redirect_to front_path if session[:user]
  end
end

class SessionsController < ApplicationController
  before_action :reject_user_has_set_personal_information, only: [:new, :create]

  def new
  end

  def create
    session[:user] = params[:department] + " " + params[:grade]
    redirect_to front_path
  end

  def destroy
    session[:user] = nil
    redirect_to setting_path
  end

  private

  def reject_user_has_set_personal_information
    redirect_to front_path if session[:user]
  end
end

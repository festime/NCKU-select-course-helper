class SessionsController < ApplicationController

  def new
  end

  def create
    session[:user] = params[:department] + " " + params[:grade]
    binding.pry
    redirect_to front_path
  end

  def destroy
    session[:user] = nil
    redirect_to setting_path
  end
end

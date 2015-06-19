class UpdateCoursesController < ApplicationController
  def new
  end

  def create
    if params[:password] == ENV["password"]
      CourseUpdate.run
      redirect_to root_path

    else
      redirect_to update_courses_path
    end
  end
end

class UpdateCoursesController < ApplicationController
  def new
  end

  def create
    if params[:password] == ENV["password"]
      CourseUpdate.new.update_general_education_courses
      CourseUpdate.new.update_courses_of_departments
      redirect_to root_path

    else
      redirect_to update_courses_path
    end
  end
end

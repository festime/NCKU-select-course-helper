class CoursesController < ApplicationController
  before_action :require_setting
  before_action :initialize_courses, only: [:front, :search]
  before_action :set_institute_code, only: [:front, :search]



  def front
  end

  def search
    respond_to do |format|
      format.js do
        if params[:checkboxes]
          search_keywords = params[:checkboxes]
        elsif params[:other_department]
          search_keywords = [
            "#{department_name_of(params[:other_department][:institute_code])} " +
            "#{params[:other_department][:institute_code]} " +
            "year=#{params[:other_department][:year]}"
          ]
        end

        @search_result = CourseSearchService.new(
          search_keywords: search_keywords,
          courses_id: session[:courses_id]
        ).search
      end
    end
  end

  def add_course
    respond_to do |format|
      format.js do
        @new_course = Course.find(params[:course_id])

        if !(session[:courses_id].include? params[:course_id].to_i) &&
           CourseSearchService.new(courses_id: session[:courses_id]).available_courses([@new_course]) == [@new_course]
          session[:courses_id] << params[:course_id].to_i
          @courses = Course.find(session[:courses_id])
        else
          @new_course = nil
        end
      end
    end
  end

  def remove_course
    respond_to do |format|
      format.js do
        if session[:courses_id].include? params[:course_id].to_i
          session[:courses_id].delete(params[:course_id].to_i)
        end
      end
    end
  end

  def default_table
    session[:courses_id] = session[:obligatory_courses_id].clone
    redirect_to front_path
  end



  private

  def require_setting
    unless user_has_finished_necessary_settings?
      redirect_to setting_path
    end
  end

  def initialize_courses
    @courses = Course.find(session[:courses_id])
  end

  def set_institute_code
    @institute_code = session[:institute_code]
  end
end

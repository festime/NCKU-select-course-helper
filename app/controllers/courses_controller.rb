class CoursesController < ApplicationController
  before_action :require_setting
  before_action :initialize_courses, only: [:front, :search]
  before_action :set_institute_code, only: [:front, :search]



  def front
    current_user_freetime
  end

  def search
    @search_result = CourseSearchService.new(params).search

    render :front
  end

  def add_course
    respond_to do |format|
      format.js do
        @new_course = Course.find(params[:course_id])
        binding.pry
        if !session[:courses_id].include? params[:course_id].to_i &&
           CourseSearchService.available_courses([@new_course], current_user_freetime) == [@new_course]
          session[:courses_id] << params[:course_id].to_i
        end
      end
    end
  end

  def remove_course
    respond_to do |format|
      format.js do
        if session[:courses_id].incldue? params[:course_id].to_i
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
    @courses = Course.find(session[:courses_id]).map do |course|
      {
        id: course.id,
        course_name: course.course_name,
        schedule: course.well_formatted_schedule,
        instructor: course.instructor,
        credits: course.credits,
        classroom: course.classroom,
        remark: course.remark
      }
    end

    #@courses.delete_if do |course|
      #course[:course_name] =~ /通識課程|歷史|基礎國文（一）|基礎國文（二）/ ||
      #course[:course_name] =~ /英文（含口語訓練）|哲學與藝術|體育（三）/ ||
      #course[:course_name] =~ /體育（四）|公民/
    #end
  end

  def set_institute_code
    @institute_code = session[:institute_code]
  end

  def current_user_freetime
    courses_schedule = Course.find(session[:courses_id]).collect do |course|
      course.well_formatted_schedule
    end

    courses_schedule.inject do |result, schedule|
      result.merge(schedule) {|day, result_schedule, new_schedule| result_schedule | new_schedule}
    end

    user_freetime = {
      '1' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9'],
      '2' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9'],
      '3' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9'],
      '4' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9'],
      '5' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9']
    }

    courses_schedule.each do |course_schedule|
      course_schedule.each do |day, schedule|
        user_freetime[day] -= schedule
      end
    end

    user_freetime
  end
end

class CoursesController < ApplicationController
  before_action :require_setting
  before_action :initialize_courses
  before_action :set_institute_code



  def front
  end

  def search
    @search_result = CourseSearchService.new(params).search

    render :front
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
end

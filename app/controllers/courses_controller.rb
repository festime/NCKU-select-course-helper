class CoursesController < ApplicationController
  before_action :require_setting
  before_action :initialize_courses



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

  def available_elective_classes
    result = []

    params[:elective].to_enum.with_index(1) do |array, year|
      checkbox_value = array[1]

      if checkbox_value.present?
        ids_of_courses = Course.where(
          "year LIKE ? AND elective_or_required LIKE ? AND
           institute_code LIKE ?",
          year.to_s,
          "選修",
          institute_code_of_current_user
        ).pluck(:id)
        schedules_of_courses = Course.where(
          "year LIKE ? AND elective_or_required LIKE ? AND
           institute_code LIKE ?",
          year.to_s,
          "選修",
          institute_code_of_current_user
        ).pluck(:schedule).collect do |schedule|
          handle_schedule!(schedule)
        end

        id_of_available_courses = []
        schedules_of_courses.each_with_index do |course_schedule, index|
          valid = true
          course_schedule.each do |day, array_of_time|
            array_of_time.each do |time|
              if !params[:freetime][day].include? time
                valid = false
                break
              end
            end
          end

          id_of_available_courses << ids_of_courses[index] if valid
        end

        result += Course.find(id_of_available_courses)
      end
    end

    return result
  end

  def institute_code_of_current_user
    session[:institute_code]
  end
end

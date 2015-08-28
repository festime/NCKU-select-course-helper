class SessionsController < ApplicationController
  before_action :reject_user_has_set_personal_information, only: [:new, :create]

  def new
  end

  def create
    courses_id = Course.where(
      "institute_code LIKE ? AND
       year LIKE ? AND
       elective_or_required LIKE ? AND
       class_name LIKE ?",
      params[:institute_code],
      params[:grade],
      "%必%",
      "%#{params[:class_name]}%"
    ).collect do |course|
      course.id
    end

    courses_id.delete_if do |course_id|
      course_name = Nokogiri::HTML(Course.find(course_id).course_name).text

      course_name =~ /通識課程|英文（含口語訓練）|哲學與藝術/ ||
      course_name =~ /基礎國文（一）|基礎國文（二）/ ||
      course_name == "歷史" ||
      course_name == "公民"
    end

    session[:institute_code] = params[:institute_code]
    session[:courses_id] = courses_id
    session[:obligatory_courses_id] = session[:courses_id].clone

    flash[:warning] = "課程人數餘額的資料可能不是最即時的"

    redirect_to front_path
  end

  def destroy
    session[:institute_code] = session[:courses_id] = session[:obligatory_courses_id] = nil
    redirect_to setting_path
  end

  private

  def reject_user_has_set_personal_information
    redirect_to front_path if user_has_finished_necessary_settings?
  end
end

class UpdateCoursesController < ApplicationController
  def new
  end

  def create
    if params[:password] == ENV["password"]
      CourseUpdate.new.update_general_education_courses
      flash[:success] = "通識類課程更新成功！"
      redirect_to update_courses_path

    elsif params[:password] == ENV["front_departments"]
      departments = [
        '中文系',
        '外文系',
        '歷史系',
        '台文系',
        '數學系',
        '物理系',
        '化學系',
        '地科系',
        '光電系',
        '機械系',
        '化工系',
        '資源系',
        '材料系',
        '土木系'
      ]
      CourseUpdate.new.update_courses_of_departments(departments)
      flash[:success] = "前半系課程更新成功！"
      redirect_to update_courses_path

    elsif params[:password] == ENV["middle_departments"]
      departments = [
        '水利系',
        '工科系',
        '系統系',
        '航太系',
        '環工系',
        '測量系',
        '醫工系',
        '會計系',
        '統計系',
        '工資系',
        '企管系',
        '交管系',
        '護理系',
        '醫技系'
      ]
      CourseUpdate.new.update_courses_of_departments(departments)
      flash[:success] = "中間系課程更新成功！"
      redirect_to update_courses_path

    elsif params[:password] == ENV["back_departments"]
      departments = [
        '醫學系',
        '物治系',
        '職治系',
        '藥學系',
        '法律系',
        '政治系',
        '經濟系',
        '心理系',
        '電機系',
        'CSIE',
        '建築系',
        '都計系',
        '工設系',
        '生科系'
      ]
      CourseUpdate.new.update_courses_of_departments(departments)
      flash[:success] = "後半系課程更新成功！"
      redirect_to update_courses_path

    else
      flash[:danger] = "失敗！"
      redirect_to update_courses_path
    end
  end
end

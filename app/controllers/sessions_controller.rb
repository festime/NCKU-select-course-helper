class SessionsController < ApplicationController
  before_action :reject_user_has_set_personal_information, only: [:new, :create]

  def new
  end

  def create
    session[:institute_code] = params[:institute_code]
    session[:grade] = params[:grade]
    session[:class_name] = params[:class_name]
    flash[:info] = "點擊課表最上面那列星期幾的格子，或點課表內的格子\
                    ，格子會變綠色，表示你想找的時段，點紅色格子可以把那格必修課取消掉\
                    ，選好想要的課程類別，最後按下面那顆找課按鈕"
    flash[:warning] = "課程人數餘額的資料可能不是最即時的"

    redirect_to front_path
  end

  def destroy
    session[:institute_code] = session[:grade] = session[:class_name] = nil
    redirect_to setting_path
  end

  private

  def reject_user_has_set_personal_information
    redirect_to front_path if user_has_finished_necessary_settings?
  end
end

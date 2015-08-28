class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :user_has_finished_necessary_settings?

  def user_has_finished_necessary_settings?
    session[:institute_code] &&
    session[:courses_id] &&
    session[:obligatory_courses_id]
  end

  def department_name_of(institute_code)
    department_name_to_institute_code.invert[institute_code]
  end

  def department_name_to_institute_code
    {
      '中文系' => 'B1',
      '外文系' => 'B2',
      '歷史系' => 'B3',
      '台文系' => 'B5',
      '數學系' => 'C1',
      '物理系' => 'C2',
      '化學系' => 'C3',
      '地科系' => 'C4',
      '光電系' => 'F8',
      '機械系' => 'E1',
      '化工系' => 'E3',
      '資源系' => 'E4',
      '材料系' => 'E5',
      '土木系' => 'E6',
      '水利系' => 'E8',
      '工科系' => 'E9',
      '能源學程' => 'F0',
      '系統系' => 'F1',
      '航太系' => 'F4',
      '環工系' => 'F5',
      '測量系' => 'F6',
      '醫工系' => 'F9',
      '會計系' => 'H1',
      '統計系' => 'H2',
      '工資系' => 'H3',
      '企管系' => 'H4',
      '交管系' => 'H5',
      '護理系' => 'I2',
      '醫技系' => 'I3',
      '醫學系' => 'I5',
      '物治系' => 'I6',
      '職治系' => 'I7',
      '藥學系' => 'I8',
      '法律系' => 'D2',
      '政治系' => 'D4',
      '經濟系' => 'D5',
      '心理系' => 'D8',
      '電機系' => 'E2',
      '資訊系' => 'F7',
      '建築系' => 'E7',
      '都計系' => 'F2',
      '工設系' => 'F3',
      '生科系' => 'C5'
    }
  end
end

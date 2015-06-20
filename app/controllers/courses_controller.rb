class CoursesController < ApplicationController
  before_action :require_setting



  def front
    @obligatory_courses = Course.where(
      institute_code: session[:user].split(' ')[0],
      year: session[:user].split(' ')[1],
      elective_or_required: "必修"
    ).where(
      'class_name LIKE ?', "%#{session[:user].split(' ')[2]}%"
    ).map do |course|
      {course_name: course.course_name, schedule: handle_schedule!(course.schedule)}
    end
  end

  def search
    @courses = {}
    params[:core].each do |type, selected|
      type = type.to_sym
      result = available_general_education_classes(:core, type)
      @courses[type] = result
    end
    params[:cross].each do |type, selected|
      type = type.to_sym
      result = available_general_education_classes(:cross, type)
      @courses[type] = result
    end

    render :front
  end

  private

  def require_setting
    redirect_to setting_path unless session[:user]
  end

  def handle_schedule!(schedule)
    result = {"1" => [], "2" => [], "3" => [], "4" => [], "5" => []}

    loop do
      continuous_courses = schedule[/\[\d\]\d~\d/]

      if continuous_courses
        # "[1]2~3"
        result[continuous_courses[1]] += (continuous_courses[3]..continuous_courses[5]).to_a
      else
        break
      end

      schedule.sub!(/\[\d\]\d~\d/, "")
    end

    loop do
      single_course = schedule[/\[\d\](\d|N)/]

      if single_course
        # "[2]5"
        result[single_course[1]] += [single_course[3]]
      else
        break
      end

      schedule.sub!(/\[\d\](\d|N)/, "")
    end

    result.select {|key, value| value != []}
  end

  def available_general_education_classes(type, sub_type)
    data_hash = {
      core: {
        philosophy_art: {type: "哲學與藝術", model: GeneralEducation},
        citizenship_history: {type: "公民與歷史", model: CitizenshipHistory},
        basic_chinese: {type: "基礎國文", model: BasicChinese},
        freshman_english: {type: "大一英文", model: InternationalLanguage},
        sophomore_english: {type: "大二英文", model: InternationalLanguage}
      },
      cross: {
        humanities: {type: "人文學", model: GeneralEducation},
        life_science_health: {type: "生命科學與健康", model: GeneralEducation},
        science_engineering: {type: "自然與工程科學", model: GeneralEducation},
        social_science: {type: "社會科學", model: GeneralEducation},
        integrated: {type: "科際整合", model: GeneralEducation}
      }
    }

    search_term = data_hash[type][sub_type][:type]
    model = data_hash[type][sub_type][:model]

    if params[type][sub_type].present?
      collection_of_id = model.where(category: search_term).pluck(:id)
      schedules = model.where(category: search_term).pluck(:schedule).collect do |schedule|
        handle_schedule!(schedule)
      end
      #schedules = handle_schedules!()

      id_of_available_courses = []
      schedules.each_with_index do |schedule, index|
        schedule.each do |day, array_of_time|
          valid = true
          array_of_time.each do |time|
            if !params[:freetime][day].include? time
              valid = false
              break
            end
          end

          id_of_available_courses << collection_of_id[index] if valid
        end
      end

      return model.find(id_of_available_courses)
    end

    return []
  end
end

class CoursesController < ApplicationController



  def front
  end

  def search
    binding.pry
    redirect_to front_path
  end

  private

  def handle_schedule!(schedule)
    result = {}

    loop do
      continuous_courses = schedule[/\[\d\]\d~\d/]

      if continuous_courses
        # "[1]2~3"
        result[continuous_courses[1]] = (continuous_courses[3]..continuous_courses[5]).to_a
      else
        break
      end

      schedule.gsub!(/\[\d\]\d~\d/, "")
    end

    loop do
      single_course = schedule[/\[\d\]\d/]

      if single_course
        # "[2]5"
        result[single_course[1]] = [single_course[3]]
      else
        break
      end

      schedule.gsub!(/\[\d\]\d/, "")
    end

    result
  end

  def available_general_education_classes(category, sub_category)
    data_hash = {
      core: {
        philosophy_art: {category: "哲學與藝術", model: GeneralEducation},
        citizenship_history: {category: "公民與歷史", model: CitizenshipHistory},
        basic_chinese: {category: "基礎國文", model: BasicChinese},
        freshman_english: {category: "大一英文", model: InternationalLanguage},
        sophomore_english: {category: "大二英文", model: InternationalLanguage}
      },
      cross: {
        humanities: {category: "人文學", model: GeneralEducation},
        life_science_health: {category: "生命科學與健康", model: GeneralEducation},
        science_engineering: {category: "自然與工程科學", model: GeneralEducation},
        social_science: {category: "社會科學", model: GeneralEducation},
        integrated: {category: "科際整合", model: GeneralEducation}
      }
    }

    search_term = data_hash[category][sub_category][:category]
    model = data_hash[category][sub_category][:model]

    if params[category][sub_category].present?
      collection_of_id = model.where(category: search_term).pluck(:id)
      schedules = model.where(category: search_term).pluck(:schedule).collect do |schedule|
        handle_schedule!(schedule)
      end

      id_of_satisfied_courses = []
      schedules.each_with_index do |schedule, index|
        schedule.each do |day, array_of_time|
          check = true
          array_of_time.each do |time|
            if !params[:freetime][day].include? time
              check = false
              break
            end
          end

          id_of_satisfied_courses << collection_of_id[index] if check
        end
      end

      model.find(id_of_satisfied_courses)
    end
  end

  def available_chinese_courses
    if params[:core][:basic_chinese].present?
      collection_of_id = BasicChinese.where(category: "基礎國文").pluck(:id)
      schedules = BasicChinese.where(category: "基礎國文").pluck(:schedule).collect do |schedule|
        handle_schedule!(schedule)
      end

      id_of_satisfied_courses = []
      schedules.each_with_index do |schedule, index|
        schedule.each do |day, array_of_time|
          check = true
          array_of_time.each do |time|
            if !params[:freetime][day].include? time
              check = false
              break
            end
          end

          id_of_satisfied_courses << collection_of_id[index] if check
        end
      end

      BasicChinese.find(id_of_satisfied_courses)
    end
  end
end

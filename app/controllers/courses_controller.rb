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

  def available_core_general_education_classes(category_symbol, category_model)
    if params[:core][category_symbol].present?
      schedules = category_model.pluck(:schedule).collect do |schedule|
        handle_schedule!(schedule)
      end

      id_of_satisfied_courses = []
      schedules.to_enum.with_index(1) do |schedule, id|
        schedule.each do |day, array_of_time|
          check = true
          array_of_time.each do |time|
            if !params[:freetime][day].include? time
              check = false
              break
            end
          end

          id_of_satisfied_courses << id if check
        end
      end

      category_model.find(id_of_satisfied_courses)
    end
  end
end

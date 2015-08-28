class CourseSearchService

  def initialize(search_keywords: [], courses_id:)
    @search_keywords = search_keywords
    @courses_id = courses_id
  end

  def search
    search_result = {}

    @search_keywords.each do |keyword|
      category_name, institute_code, condition_string = keyword.split(' ')

      first_argument = "institute_code LIKE ?"
      remaining_arguments = [institute_code]

      if condition_string
        conditions = condition_string.split('&&')

        while conditions.count > 0
          first_argument += " AND #{conditions[0].split('=').first} LIKE ?"
          remaining_arguments << conditions[0].split('=').last
          conditions.shift
        end
      end

      desired_courses = Course.where(first_argument, *remaining_arguments)
      search_result[category_name] = available_courses(desired_courses)
    end

    search_result
  end

  def available_courses(desired_courses)
    user_freetime = current_user_freetime

    desired_courses.select do |course|
      compatible = true

      #begin
      course.well_formatted_schedule.each do |day, day_schedule|
        if day_schedule - user_freetime[day] != []
          compatible = false
          break
        end
      end
      #rescue => e
        #p e.message
        #p e.backtrace
      #end

      compatible
    end
  end

  private

  def current_user_freetime
    user_freetime = {
      '1' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9'],
      '2' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9'],
      '3' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9'],
      '4' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9'],
      '5' => ['1', '2', '3', '4', 'N', '5', '6', '7', '8', '9']
    }

    current_courses_schedule.each do |day, course_schedule|
      user_freetime[day] -= course_schedule
    end

    user_freetime
  end

  def current_courses_schedule
    courses_schedule = Course.find(@courses_id).collect do |course|
      course.well_formatted_schedule
    end

    courses_schedule.inject do |result, schedule|
      result.merge(schedule) {|day, result_schedule, new_schedule| result_schedule | new_schedule}
    end
  end
end

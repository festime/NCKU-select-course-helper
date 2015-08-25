class CourseSearchService

  def initialize(params)
    @courses = {}
    @checkbox_values = params[:checkboxes]
    @user_freetime = params[:freetime].clone
    @user_freetime.each do |day, freetime|
      @user_freetime[day] = freetime.split('')
    end
  end

  def search
    search_result = {}

    @checkbox_values.each do |value|
      category_name, institute_code, condition_string = value.split(' ')

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

      search_result[category_name] = filter_courses(first_argument, remaining_arguments)
    end

    search_result
  end

  private

  def filter_courses(first_argument, remaining_arguments)
    all_courses = Course.where(first_argument, *remaining_arguments)

    all_courses.select do |course|
      compatible = true

      begin
        course.well_formatted_schedule.each do |day, day_schedule|
          if day_schedule - @user_freetime[day] != []
            compatible = false
            break
          end
        end
      rescue => e
        p e.message
        p e.backtrace
      end

      compatible
    end
  end
end

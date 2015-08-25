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
      @conditions = { institute_code: institute_code }

      if condition_string
        key = condition_string.split('=').first.to_sym
        value = condition_string.split('=').last
        @conditions[key] = value
      end

      search_result[category_name] = filter_courses
    end

    search_result
  end

  private

  def filter_courses
    all_courses = Course.where(@conditions)

    all_courses.select do |course|
      compatible = true

      course.well_formatted_schedule.each do |day, day_schedule|
        if day_schedule - @user_freetime[day] != []
          compatible = false
          break
        end
      end

      compatible
    end
  end
end

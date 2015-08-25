class Course < ActiveRecord::Base
  validates_presence_of :course_name, :institute_code,
                        :elective_or_required, :credits,
                        :selected, :space_available,
                        :schedule

  def well_formatted_schedule
    result = {"1" => [], "2" => [], "3" => [], "4" => [], "5" => []}
    schedule_clone = schedule.clone

    loop do
      continuous_courses = schedule_clone[/\[\d\]\d~\d/]

      if continuous_courses
        # "[1]2~3"
        result[continuous_courses[1]] += (continuous_courses[3]..continuous_courses[5]).to_a
        schedule_clone.sub!(/\[\d\]\d~\d/, "")
      else
        break
      end
    end

    loop do
      single_course = schedule_clone[/\[\d\](\d|N)/]

      if single_course
        # "[2]5"
        result[single_course[1]] += [single_course[3]]
        schedule_clone.sub!(/\[\d\](\d|N)/, "")
      else
        break
      end
    end

    result.select {|day, free_time| free_time != []}
  end
end

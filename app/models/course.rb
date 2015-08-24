class Course < ActiveRecord::Base
  validates_presence_of :course_name, :institute_code,
                        :elective_or_required, :credits,
                        :selected, :space_available,
                        :schedule
end

class AddIndexToInstituteCodeOfCourses < ActiveRecord::Migration
  def change
    add_index :courses, :institute_code
  end
end

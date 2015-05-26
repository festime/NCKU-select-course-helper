class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :institute_code
      t.string :serial_number
      t.string :year
      t.string :category
      t.boolean :taught_in_english
      t.string :course_name
      t.string :elective_or_required
      t.integer :credits
      t.string :instructor
      t.string :space_available
      t.string :schedule
      t.string :classroom
      t.string :remark
    end
  end
end

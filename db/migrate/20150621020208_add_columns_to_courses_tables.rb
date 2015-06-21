class AddColumnsToCoursesTables < ActiveRecord::Migration
  def change
    add_column :basic_chineses, :class_name, :string
    add_column :basic_chineses, :elective_or_required, :string
    add_column :international_languages, :class_name, :string
    add_column :international_languages, :elective_or_required, :string
    add_column :general_educations, :class_name, :string
    add_column :general_educations, :elective_or_required, :string
    add_column :citizenship_histories, :class_name, :string
    add_column :citizenship_histories, :elective_or_required, :string

    add_column :courses, :selected, :string
  end
end

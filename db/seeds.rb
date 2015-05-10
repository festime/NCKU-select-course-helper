# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'json'

Dir.glob(Rails.root + "lib/courses_data/103_2/*.json").each do |filename|
  json = File.open(filename).read
  courses = JSON.parse(json)

  case filename
    when /basic_chinese/
      courses.each { |course| BasicChinese.create(course) }
    when /citizenship_history/
      courses.each { |course| CitizenshipHistory.create(course) }
    when /general_education/
      courses.each { |course| GeneralEducation.create(course) }
    when /international_language/
      courses.each { |course| InternationalLanguage.create(course) }
  end
end

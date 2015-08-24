# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

departments = [
  '學士學程',
  '中文系',
  '外文系',
  '歷史系',
  '台文系',
  '數學系',
  '物理系',
  '化學系',
  '地科系',
  '光電系',
  '機械系',
  '化工系',
  '資源系',
  '材料系',
  '土木系',
  '水利系',
  '工科系',
  '能源學程',
  '系統系',
  '航太系',
  '環工系',
  '測量系',
  '醫工系',
  '會計系',
  '統計系',
  '工資系',
  '企管系',
  '交管系',
  '護理系',
  '醫技系',
  '醫學系',
  '物治系',
  '職治系',
  '藥學系',
  '法律系',
  '政治系',
  '經濟系',
  '心理系',
  '電機系',
  'CSIE',
  '建築系',
  '都計系',
  '工設系',
  '生科系'
]

general_education = [
  '外國語言',
  '基礎國文',
  '通識中心',
  '公民歷史'
]

CourseUpdates.new.execute(departments[0..13])
CourseUpdates.new.execute(departments[14..27])
CourseUpdates.new.execute(departments[28..-1])
CourseUpdates.new.execute(general_education)

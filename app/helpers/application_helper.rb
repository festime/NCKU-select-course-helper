module ApplicationHelper
  def type_english_to_chinese(type)
    hash = {
      philosophy_art: "哲學與藝術",
      citizenship_history: "公民與歷史",
      basic_chinese: "基礎國文",
      freshman_english: "大一英文",
      sophomore_english: "大二英文",
      humanities: "人文學",
      life_science_health: "生命科學與健康",
      science_engineering: "自然與工程科學",
      social_science: "社會科學",
      integrated: "科際整合"
    }
    hash[type]
  end

  def options_of_departments
    result = []
    departments = [
      ['中文系', 'chinese_literature'],
      ['外文系', 'foreign_languages'],
      ['歷史系', 'history'],
      ['台文系', 'taiwanese_literature'],
      ['數學系', 'mathematics'],
      ['物理系', 'physics'],
      ['化學系', 'chemistry'],
      ['地科系', 'earth_science'],
      ['光電系', 'photonics'],
      ['機械系', 'mechanical_engineering'],
      ['化工系', 'chemical_engineering'],
      ['資源系', 'resources_engineering'],
      ['材料系', 'materials_science_engineering'],
      ['土木系', 'civil_engineering'],
      ['水利系', 'hydraulic_ocean_engineering'],
      ['工科系', 'engineering_science'],
      ['系統系', 'system_engineering'],
      ['航太系', 'aeronautics_astronautics'],
      ['環工系', 'environmental_engineering'],
      ['測量系', 'geomatics'],
      ['醫工系', 'biomedical_engineering'],
      ['會計系', 'accounting'],
      ['統計系', 'statistics'],
      ['工資系', 'industrial_information_management'],
      ['企管系', 'business_administration'],
      ['交管系', 'transportation_management'],
      ['護理系', 'nursing'],
      ['醫技系', 'medical_laboratory_science'],
      ['醫學系', 'medicine'],
      ['物治系', 'physical_therapy'],
      ['職治系', 'occupational_therapy'],
      ['藥學系', 'pharmacy'],
      ['法律系', 'law'],
      ['政治系', 'political_science'],
      ['經濟系', 'economics'],
      ['心理系', 'psychology'],
      ['電機系', 'electrical_engineering'],
      ['資訊系', 'computer_science'],
      ['建築系', 'architecture'],
      ['都計系', 'urban_planning'],
      ['工設系', 'industrial_design'],
      ['生科系', 'life_science']
    ]
    numbers_of_each_school = [4, 5, 12, 5, 6, 4, 2, 3, 1]
    schools = [
      "文學院", "理學院", "工學院", "管理學院", "醫學院",
      "社會科學院", "電機資訊學院", "規劃與設計學院", "生物科學與科技學院"
    ]

    loop do
      break if departments.empty?

      departments_of_specific_school = departments.shift(numbers_of_each_school.shift)
      specific_school = schools.shift

      result << [specific_school, departments_of_specific_school]
    end

    result
  end
end

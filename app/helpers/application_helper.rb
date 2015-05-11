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
end

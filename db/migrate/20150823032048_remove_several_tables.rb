class RemoveSeveralTables < ActiveRecord::Migration
  def change
    drop_table :general_educations
    drop_table :basic_chineses
    drop_table :international_languages
    drop_table :citizenship_histories
  end
end

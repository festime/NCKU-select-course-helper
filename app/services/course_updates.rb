require 'nokogiri'
require 'json'
require 'mechanize'

class CourseUpdates
  def execute(departments) # departments should be an array of strings

    departments.each do |department_name|
      @courses_of_specific_department = []

      extract_courses(department_name)
      save_courses(department_name)

      puts "#{department_name}: #{@courses_of_specific_department.count} // #{Course.count}"
    end
  end

  private

    def extract_courses(department_name)
      agent = Mechanize.new
      agent.ignore_bad_chunking = true

      page = agent.get('http://course-query.acad.ncku.edu.tw/qry/index.php?lang=zh_tw')
      department_courses_page = agent.page.links.find do |link|
        link.text.include? department_name
      end.click

      department_courses_page.search('table/tbody/tr').each do |row|
        course = {}
        [
          [:institute_code, 'td[2]/text()'],
          [:serial_number, 'td[3]/text()'],
          [:class_name, 'td[6]/text()'],
          [:year, 'td[7]/a/text()'],
          [:category, 'td[8]/text()'],
          [:taught_in_english, 'td[10]/text()'],
          [:course_name, 'td[11]/a'],
          [:elective_or_required, 'td[12]/text()'],
          [:credits, 'td[13]/text()'],
          [:instructor, 'td[14]/text()'],
          [:selected, 'td[15]/text()'],
          [:space_available, 'td[16]/text()'],
          [:schedule, 'td[17]/text()'],
          [:classroom, 'td[18]/a/text()'],
          [:remark, 'td[19]/text()']
        ].each do |column, xpath|
          case column
            when :course_name
              remain_course_name_link(course, row, xpath)
            when :taught_in_english
              taught_in_english = row.search(xpath).text.strip
              course[column] = (taught_in_english =~ /Y/ ? true : false)
            else
              course[column] = row.search(xpath).text.strip #.gsub(/\s+/, "")
          end
        end

        if course[:course_name].present?
          course[:classroom].gsub!(/\s+/, " ")

          if duplicate_course?(course)
            @courses_of_specific_department.last[:schedule] += " #{course[:schedule]}"
          else
            if course[:department] =~ /基礎國文/
              course[:category] = '基礎國文'
            elsif course[:department] =~ /外國語言/ &&
                  course[:course_name] =~ /英文/ &&
                  course[:year] == '1'
              course[:category] = '大一英文'
            end

            @courses_of_specific_department << course
          end
        end
      end
    end

    def save_courses(department_name)
      courses_in_database = Course.where(institute_code: code_of(department_name))

      if courses_in_database.count == 0
        @courses_of_specific_department.each {|course| Course.create!(course)}
      else
        ActiveRecord::Base.transaction do
          begin
            courses_in_database.zip(@courses_of_specific_department).each do |course_in_database, realtime_course_data|
              course_in_database.update(selected: realtime_course_data[:selected])
            end
          rescue => e
            p e.message
          end
        end
      end
    end

    def remain_course_name_link(course, row, xpath)
      course[:course_name] = row.search(xpath).to_s.strip
    end

    def duplicate_course?(course)
      if course[:institute_code] == "" &&
         course[:serial_number] == "" &&
         course[:course_name] == @courses_of_specific_department.last[:course_name]
        return true
      else
        return false
      end
    end

    def code_of(department_name)
      hash = {
        '學士學程' => 'AN',
        '中文系' => 'B1',
        '外文系' => 'B2',
        '歷史系' => 'B3',
        '台文系' => 'B5',
        '數學系' => 'C1',
        '物理系' => 'C2',
        '化學系' => 'C3',
        '地科系' => 'C4',
        '光電系' => 'F8',
        '機械系' => 'E1',
        '化工系' => 'E3',
        '資源系' => 'E4',
        '材料系' => 'E5',
        '土木系' => 'E6',
        '水利系' => 'E8',
        '工科系' => 'E9',
        '能源學程' => 'F0',
        '系統系' => 'F1',
        '航太系' => 'F4',
        '環工系' => 'F5',
        '測量系' => 'F6',
        '醫工系' => 'F9',
        '會計系' => 'H1',
        '統計系' => 'H2',
        '工資系' => 'H3',
        '企管系' => 'H4',
        '交管系' => 'H5',
        '護理系' => 'I2',
        '醫技系' => 'I3',
        '醫學系' => 'I5',
        '物治系' => 'I6',
        '職治系' => 'I7',
        '藥學系' => 'I8',
        '法律系' => 'D2',
        '政治系' => 'D4',
        '經濟系' => 'D5',
        '心理系' => 'D8',
        '電機系' => 'E2',
        'CSIE' => 'F7',
        '建築系' => 'E7',
        '都計系' => 'F2',
        '工設系' => 'F3',
        '生科系' => 'C5',
        '外國語言' => 'A1',
        '基礎國文' => 'A7',
        '通識中心' => 'A9',
        '公民歷史' => 'AG'
      }
      hash[department_name]
    end
end

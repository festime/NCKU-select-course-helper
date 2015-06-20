require 'nokogiri'
require 'json'
require 'mechanize'

class CourseUpdate
  def run
    departments = [
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
    courses = []
    agent = Mechanize.new
    agent.ignore_bad_chunking = true

    departments.each do |department|
      page = agent.get('http://course-query.acad.ncku.edu.tw/qry/index.php?lang=zh_tw')
      department_courses_page = agent.page.links.find { |link| link.text.include? department }.click

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
          [:space_available, 'td[16]/text()'],
          [:schedule, 'td[17]/text()'],
          [:classroom, 'td[18]/a/text()'],
          [:remark, 'td[19]/text()']
        ].each do |column, xpath|
          case column
            when :course_name
              remain_course_name_link(course, row, xpath)
            else
              course[column] = row.search(xpath).text.strip #.gsub(/\s+/, "")
          end
        end

        if course[:course_name] != ""
          course[:classroom].gsub!(/\s+/, " ")

          if course[:institute_code] == "" && course[:serial_number] == "" &&
            course[:course_name] == courses.last[:course_name]
            courses.last[:schedule] += " #{course[:schedule]}"
          else
            courses << course
          end
        end
      end
      puts courses.count
    end

    ActiveRecord::Base.transaction do
      begin
        Course.delete_all
        courses.each { |course| Course.create(course) }
      rescue => e
        p e.message
      end
    end
  end

  private

    def remain_course_name_link(course, row, xpath)
      course[:course_name] = row.search(xpath).to_s.strip
    end
end

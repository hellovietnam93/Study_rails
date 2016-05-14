class ReadDocService
  attr_accessor :content, :course

  def initialize file_path, course
    load_file file_path
    array = index_lines @content.split "\n"
    @course = course

    array.each_with_index do |line, index|
      if array[index].is_a? Hash
        send "handle_import_syllabus_#{array[index][:import_type]}", array[index][:text], index, array
      end
    end
    @course.save
  end

  def load_file file_name
    yomu = Yomu.new file_name
    @content = yomu.text
  end

  private
  def index_lines array
    import_syllabus = Settings.import_syllabus.to_h
    array.each_with_index do |line, index|
      import_syllabus.each do |key, import|
        if /#{import}/ =~ line
          array[index] = {
            text: array[index],
            import_type: key
          }
          import_syllabus.except! import
          break
        end
      end
    end
    array
  end

  # luu 1 thong tin trong line
  ["name", "base_hours", "uid"].each do |import_type|
    define_method "handle_import_syllabus_#{import_type}" do |line, current_index, array|
      if /#{Settings.import_syllabus.send import_type}(.+)/ =~ line
        @course.send "#{import_type}=", $1.strip
      end
    end
  end

  # luu nhieu line tiep theo thanh cac belong_to
  ["course_references"].each do |import_type|
    define_method "handle_import_syllabus_#{import_type}" do |line, current_index, array|
      ((current_index + 1)...array.length).each do |index|
        return if array[index + 1].is_a? Hash
        @course.send(import_type).send :build, name: array[index] unless array[index].blank?
      end
    end
  end

  # luu nhieu line tiep theo thanh 1 thuoc tinh
  ["evaluation", "description"].each do |import_type|
    define_method "handle_import_syllabus_#{import_type}" do |line, current_index, array|
      result = []
      ((current_index + 1)...array.length).each do |index|
        break if array[index + 1].is_a? Hash
        result << array[index] unless array[index].blank?
      end

      @course.send "#{import_type}=", result.join("<br>")
    end
  end

  # do not anything
  ["learning_method", "edited_groups_outline"].each do |import_type|
    define_method "handle_import_syllabus_#{import_type}" do |line, current_index, array|

    end
  end

  def handle_import_syllabus_duration line, current_index, array
    if /#{Settings.import_syllabus.duration}.+\((\d+)-(\d+)-(\d+)-(\d+)\)/ =~ line
      ["theory_duration", "exercise_duration", "practice_duration"].each_with_index do |weigh, index|
        @course.send "#{weigh}=", $~[index + 1] rescue nil
      end
    end
  end

  def handle_import_syllabus_weight line, current_index, array
    if /#{Settings.import_syllabus.weigh}.+\sT\((\d+,\d+)\)/ =~ line
      @course.weight = $1.gsub(",", ".")
    end
  end

  def handle_import_syllabus_content_plan_details line, current_index, array
    fail_count = (current_index += 1) + 10
    while current_index < fail_count && !array[current_index].is_a?(Hash)
      if /\t\d+/ =~ array[current_index]
        syllabus = @course.syllabuses.build
        syllabus.week = array[current_index].strip
        syllabus.title = array[current_index += 1].strip
        current_index += 1
        while !array[current_index].is_a?(Hash) && (/\d+\.\d+/ =~ array[current_index] || array[current_index].blank?)
          unless array[current_index].blank?
            syllabus.syllabus_details.build title: array[current_index]
          end
          current_index += 1
        end
        fail_count = current_index + 10
      else
        current_index += 1
      end
    end
  end
end

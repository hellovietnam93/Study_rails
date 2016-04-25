class ReadDocService
  attr_accessor :content, :course

  def initialize file_path, course
    @course = course
    data = File.read file_path
    @text = Yomu.read :text, data
  end

  def load_file file
    yomu = Yomu.new 'test.doc'
    @content = yomu.text
  end

  def create_course
    @array = @text.split("\n")
    @array.each_with_index do |line, index|
      load_course line, index
    end
  end

  private
  def load_course line, index
    if (index_name = line.index("Tên học phần:")) != -1
      @course.name = line[(index_name + "Tên học phần:".length + 1)..-1].gsub("\t", "")
    elsif (index_id = line.index("Mã số:")) != -1
      @course.uid = line[(index_id+"Mã số:".length + 1)..-1].gsub("\t", "")
    elsif (index_weigh = line.index("Khối lượng:")) != 0
      line = line[(index_weigh + "Khối lượng:".length)..-1].gsub("\t", "")
      index_weigh = line.index("(") + 1
      line[index_weigh..-2]
      temp = line.split "-"
      ["theory_duration", "exercise_duration", "practice_duration"].each_with_index do |weigh, index|
        course.send "#{weigh}=", temp[index] rescue nil
      end
    elsif (index_home_work = line.index("Bài tập/BTL:")) != -1
      courses.base_hour = line.scan(/\d+/).first
    elsif (indxe_description = line.index("Nội dung vắn tắt học phần:")) != -1
      courses.description = line[(indxe_description + "Nội dung vắn tắt học phần:".length + 1)..-1]
      weigh = line.scan(/T\(\d+\,\d+\)/).first || line.scan(/T\(\d+\.\d+\)/).first
      courses.weight = weight.gsub("T(", "").gsub(")", "").gsub(",", ".")
    elsif (line.index(/\t\d+\s/) == 0)
      @syllabus = @course.syllabuses.build
      @syllabus.week = line.gsub("\t", "")
      while true
        if @array[index].index(/\t\w+/)
          @syllabus.title = @array[index].gsub("\t", "")
          break
        end
        index += 1
      end
    elsif line.index(/\d+\.\d+/)
      @syllabus.syllabus_details.build title: line
    end
  end
end

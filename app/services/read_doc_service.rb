class ReadDocService
  attr_accessor :content, :course
  def load_file file_name
    yomu = Yomu.new file_name
    @content = yomu.text
  end

  def load_course line, index, array
    if (index_name = line.index("Tên học phần:"))
      @course.name = line[(index_name + "Tên học phần:".length + 1)..-1].gsub("\t", "")
    elsif (index_id = line.index("Mã số:"))
      @course.uid = line[(index_id+"Mã số:".length + 1)..-1].gsub("\t", "")
    elsif (index_weigh = line.index("Khối lượng:"))
      line = line[(index_weigh+ "Khối lượng:".length)..-1].gsub("\t", "")
      index_weigh = line.index("(") + 1
      line[index_weigh..-2]
      temp = line.split "-"
      ["theory_duration", "exercise_duration", "practice_duration"].each_with_index do |weigh, index|
       @course.send "#{weigh}=", temp[index] rescue nil
      end
    elsif (index_home_work = line.index("Bài tập/BTL:"))
     # puts line.scan(/\d+/).first
    elsif (indxe_description = line.index("Nội dung vắn tắt học phần:"))
      while true
        index += 1
        if(!array[index].empty?)
         @course.description = array[index]
          break
        end
      end
    elsif (index_weigh_point = line.index("Đánh giá kết quả:"))
      weight = line.scan(/T\(\d+\,\d+\)/).first || line.scan(/T\(\d+\.\d+\)/).first
     @course.weight = weight.gsub("T(", "").gsub(")", "").gsub(",", ".")
    elsif (line.index(/\t\d+/) == 0)
      @syllabus = @course.syllabuses.build
      @syllabus.week = line.gsub("\t", "")
      while true
        index += 1
        if array[index].index(/\t\w+/)
          @syllabus.title = array[index].gsub("\t", "")
          break
        end
      end
    elsif line.index(/\d+\.\d+/)
      @syllabus.syllabus_details.build(title: line) if @syllabus
    end
  end

  def initialize file_name
    load_file file_name
    array = @content.split "\n"
    @course = Course.new
    array.each_with_index do |line, index|
      load_course line, index, array
    end
  end
end
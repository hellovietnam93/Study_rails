class ReadDocService
  attr_accessor :content, :course

  def initialize file_path, course
    load_file file_path
    array = @content.split "\n"
    @course = course

    array.each_with_index do |line, index|
      load_course line, index, array
    end
    @course.save
  end

  def load_file file_name
    yomu = Yomu.new file_name
    @content = yomu.text
  end

  private
  def load_course line, index, array
    if index_name = line.index(Settings.import_syllabus.name)
      @course.name = line[(index_name + Settings.import_syllabus.name.length + 1)..-1].gsub("\t", "")
    elsif index_id = line.index(Settings.import_syllabus.id)
      @course.uid = line[(index_id + Settings.import_syllabus.id.length + 1)..-1].gsub("\t", "")
    elsif index_weigh = line.index(Settings.import_syllabus.duration)
      line = line[(index_weigh + Settings.import_syllabus.duration.length)..-1].gsub("\t", "")
      index_weigh = line.index("(") + 1
      line[index_weigh..-2]
      temp = line.split "-"
      ["theory_duration", "exercise_duration", "practice_duration"].each_with_index do |weigh, index|
        @course.send "#{weigh}=", temp[index] rescue nil
      end
    elsif index_home_work = line.index(Settings.import_syllabus.base_hours)
      @course.base_hours = line.scan(/\d+/).first
    elsif indxe_description = line.index(Settings.import_syllabus.description)
      while true
        index += 1
        if(!array[index].empty?)
          @course.description = array[index]
          break
        end
      end
    elsif (index_weigh_point = line.index(Settings.import_syllabus.weight))
      weight = line.scan(/T\(\d+\,\d+\)/).first || line.scan(/T\(\d+\.\d+\)/).first
      @course.weight = weight.gsub("T(", "").gsub(")", "").gsub(",", ".")
    elsif line.index(/\t\d+/) == 0
      @syllabus = @course.syllabuses.build
      @syllabus.week = line.gsub("\t", "")
      while true
        index += 1
        if array[index].index(/\t[A-Za-z0-9_ÂĂÊƯÔƠĐâăêưôơ]/)
          @syllabus.title = array[index].gsub("\t", "")
          break
        end
      end
    elsif line.index(/\d+\.\d+/)
      @syllabus.syllabus_details.build title: line if @syllabus
    end
  end
end

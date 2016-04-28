class NewClassFrom
  def initialize

  end

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  class << self
    def model_name
      ActiveModel::Name.new self, nil, ClassRoom.name
    end
  end

  validate :valid_course

  attr_accessor :teacher
  delegate :name, :uid, :description, :course_id, :semester_id, :enroll_key,
    :class_type, :max_student, :status, :end_date, :start_date, to: :class_room
  delegate :date_start, :date_end, :title, :content, :repeat, :time_start,
    :time_end, :full_day, to: :timetable
  delegate :repeat_on, :repeat_type, :range, :day_start, :number_occur,
    :day_end, :end_type, to: :timetable_repeat

  def class_room
    @class_room ||= ClassRoom.new
  end

  def timetable
    @timetable ||= class_room.timetables.new
  end

  def timetable_repeat
    @timetable_repeat ||= timetable.timetable_repeats.new
  end

  def submit params
    params.permit!
    @params = params
    @course = Course.includes(syllabuses: :syllabus_details).find_by params[:course_id]

    class_room.attributes = params.slice :name, :uid, :description, :course_id, :semester_id, :enroll_key,
      :class_type, :max_student, :status, :end_date, :start_date

    timetable.attributes = params.slice :date_start, :date_end, :title, :content, :repeat, :time_start,
      :time_end, :full_day
    timetable_repeat.attributes = params.slice :repeat_on, :repeat_type, :range, :day_start,
      :number_occur, :day_end, :end_type
    @semester = class_room.semester

    if valid?
      class_room_service = ClassRoomService.new class_room, params[:teacher]
      class_room_service.save
      class_room.create_forum

      if !timetable.full_day? && !timetable.repeat?
        timetable.time_start = new_timer timetable.date_start, timetable.time_start
        timetable.time_end = new_timer timetable.date_end, timetable.time_end
        timetable.save!
      elsif timetable.full_day?
        timetable.time_start = timetable.date_start.at_beginning_of_day()
        timetable.time_end = timetable.date_end.at_end_of_day()
        timetable.save!
      elsif timetable.repeat?
        timetable.date_start = nil
        timetable.date_end = nil

        case timetable_repeat.repeat_type
        when "every_day"
          timetable.time_start = new_timer timetable_repeat.day_start, timetable.time_start
          timetable.time_end = new_timer timetable_repeat.day_start, timetable.time_end
          timetable.save!
          case timetable_repeat.end_type
          when "none_end"
            ((timetable_repeat.day_start+1.days).strftime(I18n.t("date.formats.default")).to_date..class_room.end_date.strftime(I18n.t("date.formats.default")).to_date).to_a.each do |date|
              start = new_timer date, timetable.time_start
              finish = new_timer date, timetable.time_end
              title = timetable.title
              Timetable.create class_room_id: class_room.id, time_start: start, time_end: finish, title: title
            end
          when "after_times"
            timetable_repeat.number_occur.times do |n|
              unless n == 0
                start = timetable.time_start + n.day
                finish = timetable.time_end + n.day
                title = timetable.title

                Timetable.create class_room_id: class_room.id, time_start: start, time_end: finish, title: title
              end
            end
          when "end_in_day"
            ((timetable_repeat.day_start+1.days).strftime(I18n.t("date.formats.default")).to_date..timetable_repeat.day_end.strftime(I18n.t("date.formats.default")).to_date).to_a.each do |date|
              start = new_timer date, timetable.time_start
              finish = new_timer date, timetable.time_end
              title = timetable.title
              Timetable.create class_room_id: class_room.id, time_start: start, time_end: finish, title: title
            end
          end
        when "every_week"
          if timetable_repeat.day_start.strftime("%A").downcase == timetable_repeat.repeat_on
            time_start = new_timer timetable_repeat.day_start, timetable.time_start
            time_end = new_timer timetable_repeat.day_start, timetable.time_end
          else
            day = nil
            (timetable_repeat.day_start.strftime(I18n.t("date.formats.default")).to_date..(timetable_repeat.day_start + 1.week - 1.day).strftime(I18n.t("date.formats.default")).to_date).to_a.each do |date|
              if date.strftime("%A").downcase == timetable_repeat.repeat_on
                day = date.to_date
              end
            end
            time_start = new_timer day, timetable.time_start
            time_end = new_timer day, timetable.time_end
          end
          timetable.update_attributes time_start: time_start, time_end: time_end
          case timetable_repeat.end_type
          when "none_end"
            ((timetable.time_start + 1.day).strftime(I18n.t("date.formats.default")).to_date..class_room.end_date.strftime(I18n.t("date.formats.default")).to_date).to_a.each do |date|
              if date.strftime("%A").downcase == timetable_repeat.repeat_on
                start = new_timer date, timetable.time_start
                finish = new_timer date, timetable.time_end
                title = timetable.title

                Timetable.create class_room_id: class_room.id, time_start: start, time_end: finish, title: title
              end
            end
          when "after_times"
            timetable_repeat.number_occur.times do |n|
              unless n == 0
                start = timetable.time_start + n.week
                finish = timetable.time_end + n.week
                title = timetable.title

                Timetable.create class_room_id: class_room.id, time_start: start, time_end: finish, title: title
              end
            end
          when "end_in_day"
            ((timetable.time_start + 1.day).strftime(I18n.t("date.formats.default")).to_date..timetable_repeat.day_end.strftime(I18n.t("date.formats.default")).to_date).to_a.each do |date|
              if date.strftime("%A").downcase == timetable_repeat.repeat_on
                start = new_timer date, timetable.time_start
                finish = new_timer date, timetable.time_end
                title = timetable.title

                Timetable.create class_room_id: class_room.id, time_start: start, time_end: finish, title: title
              end
            end
          end
        when "every_month"
          timetable.time_start = new_timer timetable_repeat.day_start, timetable.time_start
          timetable.time_end = new_timer timetable_repeat.day_start, timetable.time_end
          timetable.save

          case timetable_repeat.end_type
          when "none_end"
            months = (class_room.end_date.year * 12 + class_room.end_date.month) - (class_room.start_date.year * 12 + class_room.start_date.month)
            months.times do |n|
              unless n == 0
                start = new_timer timetable.time_start + n.month, timetable.time_start
                finish = new_timer timetable.time_end + n.month, timetable.time_end
                title = timetable.title

                Timetable.create class_room_id: class_room.id, time_start: start, time_end: finish, title: title
              end
            end
          when "after_times"
            timetable_repeat.number_occur.times do |n|
              unless n == 0
                start = new_timer (timetable.time_start + n.month), timetable.time_start
                finish = new_timer (timetable.time_end + n.month), timetable.time_end
                title = timetable.title

                Timetable.create class_room_id: class_room.id, time_start: start, time_end: finish, title: title
              end
            end
          when "end_in_day"
            months = (class_room.end_date.year * 12 + class_room.end_date.month) - (timetable_repeat.day_end.year * 12 + timetable_repeat.day_start.month)
            months.times do |n|
              unless n == 0
                start = new_timer timetable.time_start + n.month, timetable.time_start
                finish = new_timer timetable.time_end + n.month, timetable.time_end
                title = timetable.title

                Timetable.create class_room_id: class_room.id, time_start: start, time_end: finish, title: title
              end
            end
          end
        end

        timetable_repeat.save!
      end
      true
    else
      false
    end
  end

  private
  def new_timer date, time
    Time.new date.year, date.month, date.day, time.hour, time.strftime("%M").to_i
  end

  def create_timetable_detail

  end

  def valid_course
    if @course
      unique_id_in_semester
    else
      errors.add :course_not_found, I18n.t("class_rooms.errors.course_not_found")
    end
  end

  def unique_id_in_semester
    if @semester.class_rooms.exists? uid: class_room.uid
      errors.add :existed_in_semester, I18n.t("class_rooms.errors.existed_in_semester",
        id: class_room.uid, semester: @semester.name)
    else
      belongs_to_time_of_semester
    end
  end

  def belongs_to_time_of_semester
    if @semester.start_date <= class_room.start_date && @semester.end_date >= class_room.end_date
      valid_date_of_class
    else
      errors.add :class_time_overtime_semester,
        I18n.t("class_rooms.errors.class_time_overtime_semester", semester: @semester.name)
    end
  end

  def valid_date_of_class
    if class_room.start_date > class_room.end_date
      errors.add :not_valid_class_time, I18n.t("class_rooms.errors.not_valid_class_time")
    else
      check_class_learning_time
    end
  end

  def check_class_learning_time
    @total_hours = eval "(#{@course.theory_duration} + #{@course.exercise_duration}) * #{@course.base_hours}"
    @range_days = (class_room.end_date - class_room.start_date) / 3600 / 24

    if @range_days * 24 < @total_hours
      errors.add :learning_time_class_not_enough,
        I18n.t("class_rooms.errors.learning_time_class_not_enough", course: @course.uid)
    else
      if timetable.title.present?
        valid_date_timetable
      end
    end
  end

  def valid_date_timetable
    if !timetable.repeat? && !timetable.full_day?
      verify_presence_date
    elsif timetable.full_day?
      if timetable.date_start.nil?
        errors.add :date_start, I18n.t("class_rooms.errors.timetables.date_start")
      elsif timetable.date_end.nil?
        errors.add :date_end, I18n.t("class_rooms.errors.timetables.date_end")
      else
        if !(class_room.start_date <= timetable.date_start && class_room.end_date >= timetable.date_end)
          errors.add :time_timetable_overtime_class,
            I18n.t("class_rooms.errors.timetables.time_timetable_overtime_class", class_name: class_room.uid)
        elsif timetable.date_start > timetable.date_end
          errors.add :not_valid_date_timetable,
            I18n.t("class_rooms.errors.timetables.not_valid_date_timetable")
        end
      end
    elsif timetable.repeat?
      verify_time_of_timetable_repeat
    end
  end

  def verify_presence_date
    if timetable.date_start.nil?
      errors.add :date_start, I18n.t("class_rooms.errors.timetables.date_start")
    elsif timetable.date_end.nil?
      errors.add :date_end, I18n.t("class_rooms.errors.timetables.date_end")
    else
      verify_date_of_timetable
    end
  end

  def verify_date_of_timetable
    if class_room.start_date <= timetable.date_start && class_room.end_date >= timetable.date_end
      if timetable.date_start > timetable.date_end
        errors.add :not_valid_date_timetable,
          I18n.t("class_rooms.errors.timetables.not_valid_date_timetable")
      else
        verify_time_of_timetable
      end
    else
      errors.add :time_timetable_overtime_class,
        I18n.t("class_rooms.errors.timetables.time_timetable_overtime_class", class_name: class_room.uid)
    end
  end

  def verify_time_of_timetable
    if timetable.time_start > timetable.time_end
      errors.add :not_valid_time_timetable, I18n.t("class_rooms.errors.timetables.not_valid_time_timetable")
    else
      not_enough_time_to_learn_course_timetable
    end
  end

  def not_enough_time_to_learn_course_timetable
    total_hours = (timetable.date_end - timetable.date_start) * ((timetable.time_end - timetable.time_start) / 60 / 60)
    if total_hours < @total_hours
      errors.add :learning_time_class_not_enough,
        I18n.t("class_rooms.errors.learning_time_class_not_enough", course: @course.uid)
    end
  end

  def verify_time_of_timetable_repeat
    if timetable.time_start > timetable.time_end
      errors.add :not_valid_time_timetable, I18n.t("class_rooms.errors.timetables.not_valid_time_timetable")
    else
      verify_start_date_to_repeat
    end
  end

  def verify_start_date_to_repeat
    if timetable_repeat.day_start.present?
      if timetable_repeat.day_start >= class_room.start_date && timetable_repeat.day_start < class_room.end_date
        verify_finish_type
      else
        errors.add :day_start, I18n.t("class_rooms.errors.timetable_repeats.day_start.out_of_class")
      end
    else
      errors.add :day_start,
        I18n.t("class_rooms.errors.timetable_repeats.day_start.cannot_blank")
    end
  end

  def verify_finish_type
    @section_hour = (timetable.time_end - timetable.time_start) / 60 / 60

    case timetable_repeat.end_type
    when "none_end"
      calculate_total_hours_none_end
    when "after_times"
      calculate_total_hours_after_times
    when "end_in_day"
      calculate_total_hours_end_in_day
    end
  end

  def calculate_total_hours_none_end
    total_days = (class_room.end_date - timetable_repeat.day_start) / 3600 / 24

    day_number = case timetable_repeat.repeat_type
    when "every_day"
      total_days / 5
    when "every_week"
      total_days / 7
    when "every_month"
      total_days / 30
    end

    if day_number * @section_hour > @total_hours
      errors.add :base, I18n.t("class_rooms.errors.overtime")
    end
  end

  def calculate_total_hours_after_times
    total_days = class_room.end_date - timetable_repeat.day_start

    day_number = timetable_repeat.number_occur

    if day_number * @section_hour > @total_hours
      errors.add :base, I18n.t("class_rooms.errors.overtime")
    end
  end

  def calculate_total_hours_end_in_day
    if timetable_repeat.day_end.present?
      if timetable_repeat.day_end < timetable_repeat.day_start
        errors.add :day_end, I18n.t("class_rooms.errors.timetable_repeats.day_end.invalid")
      else
        if timetable_repeat.day_end > class_room.end_date
          errors.add :day_end, I18n.t("class_rooms.errors.timetable_repeats.day_end.out_of_class")
        else
          total_days = (timetable_repeat.day_end - timetable_repeat.day_start) / 3600 / 24

          day_number = case timetable_repeat.repeat_type
          when "every_day"
            total_days / 5
          when "every_week"
            total_days / 1
          when "every_month"
            total_days / 30
          end

          if (day_number * @section_hour) > @total_hours
            errors.add :base, I18n.t("class_rooms.errors.overtime")
          end
        end
      end
    else
      errors.add :day_end, I18n.t("class_rooms.errors.timetable_repeats.day_end.cannot_blank")
    end
  end
end
